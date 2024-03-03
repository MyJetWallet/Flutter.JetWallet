import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/earn/store/earn_offer_order_summary_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

@RoutePage(name: 'OfferOrderSummaryRouter')
class OfferOrderSummaryScreen extends StatelessWidget {
  const OfferOrderSummaryScreen({
    super.key,
    required this.offer,
    required this.amount,
  });

  final EarnOfferClientModel offer;
  final Decimal amount;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Provider<OfferOrderSummaryStore>(
      create: (context) => OfferOrderSummaryStore(
        offer: offer,
        amount: amount,
      ),
      builder: (context, child) {
        final store = OfferOrderSummaryStore.of(context);

        return SPageFrameWithPadding(
          loading: store.loader,
          loaderText: intl.register_pleaseWait,
          customLoader: store.showProcessing
              ? WaitingScreen(
                  primaryText: intl.buy_confirmation_local_p2p_processing_title,
                  onSkip: () {
                    navigateToRouter();
                  },
                )
              : null,
          header: SSmallHeader(
            title: intl.earn_order_summary,
            subTitle: intl.earn_transfer,
            subTitleStyle: sBodyText2Style.copyWith(
              color: colors.grey1,
            ),
          ),
          child: const _OfferOrderSummaruBody(),
        );
      },
    );
  }
}

class _OfferOrderSummaruBody extends StatelessWidget {
  const _OfferOrderSummaruBody();

  @override
  Widget build(BuildContext context) {
    final store = OfferOrderSummaryStore.of(context);
    final isBalanceHide = getIt<AppStore>().isBalanceHide;
    final formatService = getIt.get<FormatService>();
    return Observer(
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WhatToWhatConvertWidget(
              isLoading: false,
              fromAssetIconUrl: store.currency.iconUrl,
              fromAssetDescription: intl.earn_crypto_wallet,
              fromAssetValue: isBalanceHide ? '**** ${store.currency.symbol}' : store.currency.volumeAssetBalance,
              fromAssetBaseAmount: isBalanceHide
                  ? '**** ${sSignalRModules.baseCurrency.symbol}'
                  : '≈${marketFormat(
                      decimal: formatService.convertOneCurrencyToAnotherOne(
                        fromCurrency: store.currency.symbol,
                        fromCurrencyAmmount: store.currency.assetBalance,
                        toCurrency: sSignalRModules.baseCurrency.symbol,
                        baseCurrency: sSignalRModules.baseCurrency.symbol,
                        isMin: true,
                      ),
                      symbol: store.fiatSymbol,
                      accuracy: store.eurCurrency.accuracy,
                    )}',
              toAssetIconUrl: store.currency.iconUrl,
              toAssetDescription: intl.earn_earn,
              toAssetValue: isBalanceHide
                  ? '**** ${store.currency.symbol}'
                  : volumeFormat(decimal: store.selectedAmount, symbol: store.currency.symbol),
              toAssetBaseAmount: isBalanceHide
                  ? '**** ${sSignalRModules.baseCurrency.symbol}'
                  : '≈${marketFormat(
                      decimal: formatService.convertOneCurrencyToAnotherOne(
                        fromCurrency: store.currency.symbol,
                        fromCurrencyAmmount: store.selectedAmount,
                        toCurrency: sSignalRModules.baseCurrency.symbol,
                        baseCurrency: sSignalRModules.baseCurrency.symbol,
                        isMin: true,
                      ),
                      symbol: store.fiatSymbol,
                      accuracy: store.eurCurrency.accuracy,
                    )}',
            ),
            const SDivider(),
            const SizedBox(height: 19),
            if (store.offer.name != null && store.offer.name!.isNotEmpty)
              TwoColumnCell(
                label: intl.earn_to,
                value: store.offer.name,
                needHorizontalPadding: false,
              ),
            if (store.offer.apyRate != null)
              TwoColumnCell(
                label: intl.earn_apy_rate,
                value:
                    '${(store.offer.apyRate! * Decimal.fromInt(100)).toStringAsFixed(2).replaceFirst(RegExp(r'\.?0*$'), '')}%',
                needHorizontalPadding: false,
              ),
            TwoColumnCell(
              label: intl.earn_earning_term,
              value: store.offer.withdrawType == WithdrawType.instant
                  ? intl.earn_flexible
                  : intl.earn_freeze(store.offer.lockPeriod ?? ''),
              needHorizontalPadding: false,
              valueMaxLines: 2,
            ),
            const SizedBox(height: 7),
            ProcessingFeeRowWidget(
              fee: '0 ${store.currency.symbol}',
            ),
            const SizedBox(height: 16),
            const SDivider(),
            const SizedBox(height: 16),
            SPolicyCheckbox(
              onPrivacyPolicyTap: () {
                launchURL(context, privacyEarnLink);
              },
              onUserAgreementTap: () {
                launchURL(context, infoEarnLink);
              },
              firstText: '${intl.earn_i_have_read_and_agreed_to} ',
              userAgreementText: intl.earn_terms_and_conditions,
              betweenText: ', ',
              privacyPolicyText: intl.earn_privacy_policy,
              isChecked: store.isTermsAndConditionsChecked,
              onCheckboxTap: () {
                store.toggleCheckbox();
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: SPrimaryButton2(
                active: store.isTermsAndConditionsChecked,
                name: intl.previewBuyWithAsset_confirm,
                onTap: () {
                  sAnalytics.tapOnTheConfirmEarnDepositOrderSummaryButton(
                    assetName: store.offer.assetId,
                    earnAPYrate: store.offer.apyRate?.toStringAsFixed(2) ?? Decimal.zero.toString(),
                    earnDepositAmount: store.selectedAmount.toStringAsFixed(2),
                    earnPlanName: store.offer.description ?? '',
                    earnWithdrawalType: store.offer.withdrawType.name,
                  );
                  store.confirm();
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}
