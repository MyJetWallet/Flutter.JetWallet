import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/convert_flow/store/convert_confirmation_store.dart';
import 'package:jetwallet/features/convert_flow/widgets/convert_confirmation_info_grid.dart';
import 'package:jetwallet/utils/formatting/base/decimal_extension.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

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
      builder: (context, child) => const _ConvertConfirmationScreenBody(),
      dispose: (context, value) {
        value.cancelTimer();
        value.cancelAllRequest();
      },
    );
  }
}

class _ConvertConfirmationScreenBody extends StatelessObserverWidget {
  const _ConvertConfirmationScreenBody();

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
              onSkip: () {
                store.skipProcessing();
              },
            )
          : null,
      header: SSmallHeader(
        title: intl.buy_confirmation_title,
        subTitle: intl.sell_confirmation_convert,
        subTitleStyle: sBodyText2Style.copyWith(
          color: colors.grey1,
        ),
        onBackButtonTap: () {
          sRouter.maybePop();
        },
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                STransaction(
                  isLoading: !store.isDataLoaded,
                  fromAssetIconUrl: store.payCurrency.iconUrl,
                  fromAssetDescription: store.payCurrency.symbol,
                  fromAssetValue: (store.paymentAmount ?? Decimal.zero).toFormatCount(
                    symbol: store.payCurrency.symbol,
                    accuracy: store.payCurrency.accuracy,
                  ),
                  fromAssetBaseAmount: calculateBaseBalanceWithReader(
                    assetSymbol: store.payCurrency.symbol,
                    assetBalance: store.paymentAmount ?? Decimal.zero,
                  ).toFormatSum(
                    symbol: baseCurrency.symbol,
                    accuracy: baseCurrency.accuracy,
                  ),
                  toAssetIconUrl: store.buyCurrency.iconUrl,
                  toAssetDescription: store.buyCurrency.description,
                  toAssetValue: (store.buyAmount ?? Decimal.zero).toFormatCount(
                    accuracy: store.buyCurrency.accuracy,
                    symbol: store.buyCurrency.symbol,
                  ),
                  toAssetBaseAmount: calculateBaseBalanceWithReader(
                    assetSymbol: store.buyCurrency.symbol,
                    assetBalance: store.buyAmount ?? Decimal.zero,
                  ).toFormatSum(
                    symbol: baseCurrency.symbol,
                    accuracy: baseCurrency.accuracy,
                  ),
                ),
                ConvertConfirmationInfoGrid(
                  ourFee: (store.tradeFeeAmount ?? Decimal.zero).toFormatCount(
                    accuracy: store.tradeFeeCurreny.accuracy,
                    symbol: store.tradeFeeCurreny.symbol,
                  ),
                  totalValue: (store.paymentAmount ?? Decimal.zero).toFormatCount(
                    symbol: store.buyAsset ?? '',
                    accuracy: 2,
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
                      sAnalytics.tapOnTheButtonConfirmOnConvertOrderSummary(
                        enteredAmount: (store.isFromFixed ? store.paymentAmount : store.buyAmount).toString(),
                        convertFromAsset: store.paymentAsset ?? '',
                        convertToAsset: store.buyAsset ?? '',
                        nowInput: store.isFromFixed ? 'ConvertFrom' : 'ConvertTo',
                      );
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
