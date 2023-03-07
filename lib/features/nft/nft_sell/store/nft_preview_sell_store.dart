import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/nft/nft_sell/model/nft_sell_input.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/nft_market/nft_market_make_sell_order_request_model.dart';

part 'nft_preview_sell_store.g.dart';

class NFTPreviewSellStore extends _NFTPreviewSellStoreBase
    with _$NFTPreviewSellStore {
  NFTPreviewSellStore() : super();

  static _NFTPreviewSellStoreBase of(BuildContext context) =>
      Provider.of<NFTPreviewSellStore>(context, listen: false);
}

abstract class _NFTPreviewSellStoreBase with Store {
  NftSellInput? input;

  final loader = StackLoaderStore();

  @observable
  Decimal price = Decimal.zero;

  @observable
  Decimal priceWithFee = Decimal.zero;

  ///

  @observable
  Decimal sellPrice = Decimal.zero;

  @observable
  Decimal feePercentage = Decimal.zero;

  @observable
  Decimal receiveAmount = Decimal.zero;

  @observable
  Decimal feeAmount = Decimal.zero;

  ///

  @observable
  bool connectingToServer = false;

  @observable
  bool isLoading = true;

  @observable
  bool isProcessing = false;

  @action
  Future<void> init(NftSellInput value) async {
    isLoading = true;
    input = value;

    price = Decimal.parse(value.amount);

    try {
      final response = await sNetwork.getWalletModule().getNFTMarketPreviewSell(
            input!.nft.symbol!,
            input!.nft.tradingAsset!,
          );

      response.pick(
        onData: (data) {
          print(data);

          sellPrice = data.sellPrice;
          feePercentage = data.feePercentage;
          receiveAmount = data.receiveAmount;
          feeAmount = data.feeAmount;

          final feePrice = (feePercentage.toDouble() * price.toDouble()) / 100;

          print(feePrice);

          priceWithFee = price - Decimal.parse(feePrice.toString());

          isLoading = false;
        },
        onError: (error) {
          isLoading = false;

          print(error);

          connectingToServer = true;
        },
      );
    } catch (e) {
      print(e);

      isLoading = false;

      connectingToServer = true;
    }
  }

  @action
  Future<void> executeQuote() async {

    isProcessing = true;

    loader.startLoading();

    try {
      final model = NftMarketMakeSellOrderRequestModel(
        symbol: input!.nft.symbol,
        sellAsset: input!.nft.tradingAsset,
        sellPrice: price,
      );

      final response =
          await sNetwork.getWalletModule().postNFTMarketMakeSellOrder(model);

      if (response.hasError) {
        print(response.error!);

        _showFailureScreen(response.error!);
      } else {
        loader.finishLoading();

        isProcessing = false;
        await sRouter.push(
          SuccessScreenRouter(
            secondaryText: intl.nft_detail_confirm_order_completed,
            showProgressBar: true,
            showShareButton: true,
            onActionButton: () {
              final shareLinkNFT = '$shareLink${input!.nft.symbol!}';

              try {
                Share.share(
                  '${intl.nft_new_nft} '
                  '$shareLinkNFT ',
                );
              } catch (e) {
                rethrow;
              }
            },
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

      _showNoResponseScreen();
    }
  }

  @action
  void _showNoResponseScreen() {
    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.showNoResponseScreen_text,
        secondaryText: intl.showNoResponseScreen_text2,
        primaryButtonName: intl.serverCode0_ok,
        onPrimaryButtonTap: () {
          sRouter.replaceAll(
            [
              const HomeRouter(
                children: [PortfolioRouter()],
              ),
            ],
          );
        },
      ),
    );
  }

  @action
  void _showFailureScreen(ServerRejectException error) {
    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.previewSell_failure,
        secondaryText: error.cause,
        primaryButtonName: intl.previewSell_editOrder,
        onPrimaryButtonTap: () {
          Navigator.pop(sRouter.navigatorKey.currentContext!);
          Navigator.pop(sRouter.navigatorKey.currentContext!);
          sRouter.replaceAll([
            const HomeRouter(
              children: [
                PortfolioRouter(),
              ],
            ),
          ]);
        },
        secondaryButtonName: intl.previewSell_close,
        onSecondaryButtonTap: () => sRouter.popUntilRoot(),
      ),
    );
  }

  @computed
  String get previewHeader {
    return '${intl.previewSell_confirmSell}'
        '\n${input!.nft.name}';
  }
}
