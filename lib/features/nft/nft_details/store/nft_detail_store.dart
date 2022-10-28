import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/kyc/helper/kyc_alert_handler.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_operation_status_model.dart';
import 'package:jetwallet/features/nft/nft_details/helpers/find_nft_by_symbol.dart';
import 'package:jetwallet/features/nft/nft_details/helpers/show_not_enougn_for_buy_nft.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';
import 'package:simple_networking/modules/wallet_api/models/disclaimer/disclaimers_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/disclaimer/disclaimers_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/nft_market/nft_market_cancel_sell_order_request_model.dart';

part 'nft_detail_store.g.dart';

class NFTDetailStore extends _NFTDetailStoreBase with _$NFTDetailStore {
  NFTDetailStore() : super();

  static _NFTDetailStoreBase of(BuildContext context) =>
      Provider.of<NFTDetailStore>(context, listen: false);
}

abstract class _NFTDetailStoreBase with Store {
  CurrencyModel? currency;

  @observable
  NftMarket? nft;

  @observable
  String shortDescription = '';

  @observable
  String description = '';

  @observable
  String? imageUrl;

  @observable
  ObservableList<DisclaimerModel> disclaimers = ObservableList.of([]);

  @observable
  bool send = false;

  @observable
  bool activeButton = false;

  @observable
  String disclaimerId = '';

  @observable
  String title = '';

  @observable
  String descriptionDisclaimer = '';

  @observable
  ObservableList<DisclaimerQuestionsModel> questions = ObservableList.of([]);


  final loader = StackLoaderStore();

  final int shortLength = 39;

  @action
  Future<void> init(String nftSymbol) async {
    nft = findNFTBySymbol(nftSymbol);

    currency =
        currencyFrom(sSignalRModules.currenciesList, nft!.tradingAsset ?? '');

    final response =
        await sNetwork.getWalletModule().getNFTMarketInfo(nft!.symbol!);

    response.pick(
      onData: (data) {
        print(data);

        description = data.description ?? '';

        if (description.length >= shortLength) {
          shortDescription =
              description.replaceRange(shortLength, description.length, '...');
        }
      },
    );
  }

  @action
  Future<void> clickBuy(BuildContext context) async {
    final kyc = getIt.get<KycService>();
    final handler = getIt.get<KycAlertHandler>();

    if (kyc.depositStatus == kycOperationStatus(KycStatus.allowed)) {
      buyNft();
    } else {
      handler.handle(
        status: kyc.depositStatus,
        isProgress: kyc.verificationInProgress,
        currentNavigate: () => buyNft(),
        requiredDocuments: kyc.requiredDocuments,
        requiredVerifications: kyc.requiredVerifications,
      );
    }
  }


  @action
  Future<void> sendAnswers(Function() afterRequest) async {
    if (!activeButton) {
      return;
    }

    final answers = _prepareAnswers(questions);

    final model = DisclaimersRequestModel(
      disclaimerId: disclaimerId,
      answers: answers,
    );

    try {
      final _ = sNetwork.getWalletModule().postSaveDisclaimer(model);

      send = true;
      afterRequest();
    } catch (error) {
      print(error);
    }
  }

  @action
  List<DisclaimerAnswersModel> _prepareAnswers(
      List<DisclaimerQuestionsModel> questions,
      ) {
    final answers = <DisclaimerAnswersModel>[];

    for (final element in questions) {
      answers.add(
        DisclaimerAnswersModel(
          clientId: '',
          disclaimerId: '',
          questionId: element.questionId,
          result: true,
        ),
      );
    }

    return answers;
  }

  @action
  bool isCheckBoxActive() {
    return activeButton;
  }

  @action
  void onCheckboxTap() {
    activeButton = !activeButton;
    print(activeButton);
  }

  @action
  void disableCheckbox() {
    activeButton = false;
  }


  @action
  Future<void> initNftDisclaimer() async {

    try {
      final response =
      await sNetwork.getWalletModule().getNftDisclaimers();

      response.pick(
        onData: (data) {
          if (data.disclaimers != null) {
            final _disclaimers = <DisclaimerModel>[];
            for (final element in data.disclaimers!) {
              _disclaimers.add(
                DisclaimerModel(
                  description: element.description,
                  title: element.title,
                  disclaimerId: element.disclaimerId,
                  questions: element.questions,
                  imageUrl: element.imageUrl,
                ),
              );
            }

            disclaimers = ObservableList.of([..._disclaimers]);
            disclaimerId = _disclaimers[0].disclaimerId;
            description = _disclaimers[0].description;
            title = _disclaimers[0].title;
            imageUrl = _disclaimers[0].imageUrl;
            questions = ObservableList.of(_disclaimers[0].questions);
            activeButton = false;
          } else {
            send = true;
          }
        },
        onError: (error) {},
      );
    } catch (e) {
      print('Failed to fetch disclaimers');
    }
  }

  @action
  void buyNft() {
    if (currency!.assetBalance > nft!.sellPrice!) {
      sRouter.push(
        NFTConfirmRouter(nft: nft!),
      );
    } else {
      showBuyNFTNotEnougn(currency!);
    }
  }

  @action
  Future<void> cancelSellOrder() async {
    loader.startLoadingImmediately();

    try {
      final model = NftMarketCancelSellOrderRequestModel(
        symbol: nft!.symbol,
      );

      final response =
          await sNetwork.getWalletModule().postNFTMarketCancelSellOrder(model);

      if (response.hasError) {
        print(response.error!.cause);

        loader.finishLoadingImmediately();
      } else {
        nft = nft!.copyWith(onSell: false);

        loader.finishLoadingImmediately();
      }
    } catch (e) {
      print(e);

      loader.finishLoadingImmediately();
    }
  }

  void share(double qrBoxSize, double logoSize) {
    final colors = sKit.colors;
    print(shareLink);

    sShowBasicModalBottomSheet(
      context: sRouter.navigatorKey.currentContext!,
      pinned: ActionBottomSheetHeader(
        name: '${intl.nft_detail_share_nft}\n${nft!.name!}',
        onChanged: (String value) {},
      ),
      pinnedBottom: SizedBox(
        height: 104,
        child: Column(
          children: [
            const SDivider(),
            const SpaceH23(),
            SPaddingH24(
              child: SPrimaryButton2(
                icon: SShareIcon(
                  color: colors.white,
                ),
                active: true,
                name: intl.cryptoDeposit_share,
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
      removePinnedPadding: true,
      children: [
        Column(
          children: [
            SQrCodeBox(
              loading: false,
              data: shareLink,
              qrBoxSize: qrBoxSize,
              logoSize: logoSize,
            ),
            const SpaceH20(),
            SAddressFieldWithCopy(
              header: intl.nft_receive_matic_wallet_address,
              value: shareLink,
              realValue: shareLink,
              afterCopyText: intl.cryptoDepositWithAddress_addressCopied,
              valueLoading: false,
              needPadding: true,
              then: () {},
            ),
          ],
        ),
      ],
    );
  }
}
