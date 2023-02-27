import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/nft/nft_confirm/store/nft_promo_code_store.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:rational/rational.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';
import 'package:simple_networking/modules/wallet_api/models/nft_market/nft_market_buy_order_request_model.dart';

part 'nft_confirm_store.g.dart';

class NFTConfirmStore extends _NFTConfirmStoreBase with _$NFTConfirmStore {
  NFTConfirmStore() : super();

  static _NFTConfirmStoreBase of(BuildContext context) =>
      Provider.of<NFTConfirmStore>(context, listen: false);
}

abstract class _NFTConfirmStoreBase with Store {
  NftMarket? nft;

  @observable
  StackLoaderStore loader = StackLoaderStore();

  @observable
  bool isProcessing = false;

  @observable
  Decimal discountPercentage = Decimal.zero;

  @observable
  Decimal discountAmount = Decimal.zero;

  @observable
  Decimal totalPay = Decimal.zero;
  //Decimal get totalPay => nft!.sellPrice! + Decimal.parse(feePrice.toString());

  @action
  Future<void> init(NftMarket n) async {
    loader.startLoading();

    await getIt.get<NFTPromoCodeStore>().init();

    nft = n;

    await validate();
  }

  @action
  Future<void> validate() async {
    try {
      final response = await sNetwork.getWalletModule().getNFTMarketPreviewBuy(
            symbol: nft!.symbol!,
            promocode: getIt.get<NFTPromoCodeStore>().saved
                ? getIt.get<NFTPromoCodeStore>().promoCode
                : null,
          );

      response.pick(
        onData: (data) {
          totalPay = data.paymentAmount;
          discountAmount = data.discountAmount;
          discountPercentage = data.discountPercentage;

          //fee = data.fee;

          loader.finishLoading();
        },
        onError: (error) {
          loader.finishLoading();
        },
      );
    } catch (e) {
      loader.finishLoading();
    }
  }

  @action
  Future<void> confirm() async {
    isProcessing = true;

    loader.startLoading();

    try {
      final model = NftMarketBuyOrderRequestModel(
        requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        symbol: nft!.symbol,
        promoCode: getIt.get<NFTPromoCodeStore>().saved
            ? getIt.get<NFTPromoCodeStore>().promoCode
            : null,
      );

      final response =
          await sNetwork.getWalletModule().postNFTMarketBuyOrder(model);

      if (response.hasError) {
      } else {
        loader.finishLoading();

        isProcessing = false;

        await sRouter.push(
          SuccessScreenRouter(
            secondaryText: intl.nft_detail_confirm_order_completed,
            showProgressBar: true,
            onSuccess: (context) {
              sRouter.replaceAll([
                const HomeRouter(
                  children: [
                    PortfolioRouter(),
                  ],
                ),
              ]);
            },
          ),
        );
      }
    } catch (e) {}
  }
}
