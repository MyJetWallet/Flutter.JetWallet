import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/buy_flow/store/convert_confirmation_store.dart';
import 'package:jetwallet/features/buy_flow/ui/widgets/convert_confirmation_widgets/convert_confirmation_info_grid.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'ConvetrConfirmationRoute')
class ConvetrConfirmationScreen extends StatelessWidget {
  const ConvetrConfirmationScreen({
    super.key,
    required this.fromAsset,
    required this.toAsset,
    required this.fromAmount,
    required this.toAmount,
    required this.isFromFixed,
  });

  final CurrencyModel fromAsset;
  final CurrencyModel toAsset;
  final Decimal fromAmount;
  final Decimal toAmount;

  final bool isFromFixed;

  @override
  Widget build(BuildContext context) {
    return Provider<ConvertConfirmationStore>(
      create: (context) => ConvertConfirmationStore()
        ..loadPreview(
          newIsFromFixed: isFromFixed,
          fromAmount: fromAmount,
          fromAsset: fromAsset.symbol,
          toAsset: toAsset.symbol,
          toAmount: toAmount,
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
    final store = ConvertConfirmationStore.of(context);
    final colors = sKit.colors;

    final baseCurrency = sSignalRModules.baseCurrency;

    return SPageFrameWithPadding(
      loading: store.loader,
      loaderText: intl.register_pleaseWait,
      customLoader: store.showProcessing
          ? WaitingScreen(
              wasAction: store.wasAction,
              primaryText: intl.buy_confirmation_local_p2p_processing_title,
              onSkip: () {
                store.skipProcessing();

                navigateToRouter();
              },
            )
          : null,
      header: SSmallHeader(
        title: intl.buy_confirmation_title,
        subTitle: intl.sell_confirmation_convert,
        subTitleStyle: sBodyText2Style.copyWith(
          color: colors.grey1,
        ),
        onBackButtonTap: () => sRouter.pop(),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                WhatToWhatConvertWidget(
                  isLoading: !store.isDataLoaded,
                  fromAssetIconUrl: store.payCurrency.iconUrl,
                  fromAssetDescription: store.payCurrency.symbol,
                  fromAssetValue: volumeFormat(
                    symbol: store.payCurrency.symbol,
                    accuracy: store.payCurrency.accuracy,
                    decimal: store.paymentAmount ?? Decimal.zero,
                  ),
                  fromAssetBaseAmount: volumeFormat(
                    symbol: baseCurrency.symbol,
                    accuracy: baseCurrency.accuracy,
                    decimal: calculateBaseBalanceWithReader(
                      assetSymbol: store.payCurrency.symbol,
                      assetBalance: store.paymentAmount ?? Decimal.zero,
                    ),
                  ),
                  toAssetIconUrl: store.buyCurrency.iconUrl,
                  toAssetDescription: store.buyCurrency.description,
                  toAssetValue: volumeFormat(
                    decimal: store.buyAmount ?? Decimal.zero,
                    accuracy: store.buyCurrency.accuracy,
                    symbol: store.buyCurrency.symbol,
                  ),
                  toAssetBaseAmount: volumeFormat(
                    symbol: baseCurrency.symbol,
                    accuracy: baseCurrency.accuracy,
                    decimal: calculateBaseBalanceWithReader(
                      assetSymbol: store.buyCurrency.symbol,
                      assetBalance: store.buyAmount ?? Decimal.zero,
                    ),
                  ),
                ),
                ConvertConfirmationInfoGrid(
                  ourFee: volumeFormat(
                    decimal: store.tradeFeeAmount ?? Decimal.zero,
                    accuracy: store.tradeFeeCurreny.accuracy,
                    symbol: store.tradeFeeCurreny.symbol,
                  ),
                  totalValue: volumeFormat(
                    symbol: store.buyAsset ?? '',
                    accuracy: 2,
                    decimal: store.paymentAmount ?? Decimal.zero,
                  ),
                  paymentCurrency: store.buyCurrency,
                  asset: store.buyCurrency,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: SPrimaryButton2(
                    active: !store.loader.loading,
                    name: intl.previewBuyWithAsset_confirm,
                    onTap: () {
                      store.createPayment();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
