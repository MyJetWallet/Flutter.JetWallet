import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/features/p2p_buy/store/buy_p2p_confirmation_store.dart';
import 'package:jetwallet/features/p2p_buy/widgets/buy_p2p_confirmation_info_grid.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

import 'package:simple_networking/modules/wallet_api/models/p2p_methods/p2p_methods_responce_model.dart';

@RoutePage(name: 'BuyP2PConfirmationRoute')
class BuyP2PConfirmationScreen extends StatelessWidget {
  const BuyP2PConfirmationScreen({
    super.key,
    required this.asset,
    required this.paymentAsset,
    required this.p2pMethod,
    required this.isFromFixed,
    this.fromAmount,
    this.toAmount,
  });

  final CurrencyModel asset;
  final PaymentAsset paymentAsset;
  final P2PMethodModel p2pMethod;

  final bool isFromFixed;
  final String? fromAmount;
  final String? toAmount;

  @override
  Widget build(BuildContext context) {
    return Provider<BuyP2PConfirmationStore>(
      create: (context) => BuyP2PConfirmationStore()
        ..loadPreview(
          inputIsFromFixed: isFromFixed,
          pAmount: fromAmount ?? '0',
          bAsset: asset.symbol,
          bAmount: toAmount,
          inputP2pMethod: p2pMethod,
          inputPaymentAsset: paymentAsset,
        ),
      builder: (context, child) => const _BuyConfirmationScreenBody(),
      dispose: (context, value) {
        value.cancelTimer();
        value.cancelAllRequest();
      },
    );
  }
}

class _BuyConfirmationScreenBody extends StatelessObserverWidget {
  const _BuyConfirmationScreenBody();

  @override
  Widget build(BuildContext context) {
    final store = BuyP2PConfirmationStore.of(context);
    final colors = SColorsLight();

    return SPageFrameWithPadding(
      loading: store.loader,
      loaderText: intl.register_pleaseWait,
      customLoader: store.showProcessing
          ? WaitingScreen(
              wasAction: store.wasAction,
              primaryText: intl.buy_confirmation_local_p2p_processing_title,
              secondaryText: store.getProcessingText,
              onSkip: () {
                navigateToRouter();
              },
            )
          : null,
      header: SSmallHeader(
        title: intl.buy_confirmation_title,
        subTitle: intl.buy_confirmation_subtitle,
        subTitleStyle: sBodyText2Style.copyWith(
          color: colors.gray10,
        ),
        onBackButtonTap: () => sRouter.maybePop(),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                WhatToWhatConvertWidget(
                  isLoading: !store.isDataLoaded,
                  fromAssetIconUrl: store.buyCurrency.iconUrl,
                  fromAssetDescription: store.buyCurrency.description,
                  fromAssetValue: volumeFormat(
                    symbol: store.buyCurrency.symbol,
                    accuracy: store.buyCurrency.accuracy,
                    decimal: store.buyAmount ?? Decimal.zero,
                  ),
                  hasSecondAsset: false,
                ),
                BuyP2PConfirmationInfoGrid(
                  paymentFee: volumeFormat(
                    decimal: store.depositFeeAmount ?? Decimal.zero,
                    accuracy: store.depositFeeCurrency.accuracy,
                    symbol: store.depositFeeCurrency.symbol,
                  ),
                  ourFee: volumeFormat(
                    decimal: store.tradeFeeAmount ?? Decimal.zero,
                    accuracy: store.tradeFeeCurreny.accuracy,
                    symbol: store.tradeFeeCurreny.symbol,
                  ),
                  asset: store.buyCurrency,
                ),
                const SizedBox(height: 16),
                Text(
                  intl.buy_normally_transfer,
                  style: sCaptionTextStyle.copyWith(
                    color: colors.gray8,
                  ),
                  maxLines: 4,
                ),
                const SizedBox(height: 24),
                const SDivider(),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: SPrimaryButton2(
                    active: !store.loader.loading,
                    name: intl.previewBuyWithAsset_confirm,
                    onTap: () {
                      sAnalytics.tapOnTheButtonConfirmOnBuyOrderSummary(
                        pmType: PaymenthMethodType.ptp,
                        buyPM: 'PTP',
                        sourceCurrency: store.paymentAsset?.asset ?? '',
                        destinationWallet: store.buyAsset ?? '',
                        sourceBuyAmount: store.paymentAmount.toString(),
                        destinationBuyAmount: store.buyAmount.toString(),
                      );
                      store.createPayment();
                    },
                  ),
                ),
                const SpaceH40(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
