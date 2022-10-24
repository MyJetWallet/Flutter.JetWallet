import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:rational/rational.dart';
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
  Decimal fee = Decimal.zero;

  @computed
  double get feePrice => (nft!.sellPrice!.toDouble() * fee.toDouble()) / 100;

  @computed
  Decimal get totalPay => nft!.sellPrice! + Decimal.parse(feePrice.toString());

  @action
  Future<void> init(NftMarket n) async {
    loader.startLoading();

    nft = n;

    try {
      final response =
          await sNetwork.getWalletModule().getNFTMarketPreviewBuy(n.symbol!);

      response.pick(
        onData: (data) {
          print(data);

          fee = data.fee;

          loader.finishLoading();
        },
        onError: (error) {
          print(error);

          loader.finishLoading();
        },
      );
    } catch (e) {
      print(e);

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
      );

      final response =
          await sNetwork.getWalletModule().postNFTMarketBuyOrder(model);

      if (response.hasError) {
        print(response.error!.cause);
      } else {
        loader.finishLoading();

        isProcessing = false;

        await sRouter.push(
          SuccessScreenRouter(
            secondaryText: intl.nft_detail_confirm_order_completed,
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
    } catch (e) {
      print(e);
    }
  }
}
