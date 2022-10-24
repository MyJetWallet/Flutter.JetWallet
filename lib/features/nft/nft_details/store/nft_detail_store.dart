import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
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

  final loader = StackLoaderStore();

  final int shortLength = 39;

  @action
  Future<void> init(NftMarket data) async {
    nft = data;

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
  Future<void> clickBuy() async {
    if (currency!.assetBalance > nft!.sellPrice!) {
      await sRouter.push(
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
      then: (value) {
        //sAnalytics.receiveChooseAssetClose();
      },
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
      horizontalPinnedPadding: 0.0,
      removePinnedPadding: true,
      children: [
        SPaddingH24(
          child: Column(
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
                needPadding: false,
                then: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
