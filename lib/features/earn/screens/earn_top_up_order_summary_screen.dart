import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/earn/store/earn_top_up_order_summary_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/launch_url.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

@RoutePage(name: 'EarnTopUpOrderSummaryRouter')
class EarnTopUpOrderSummaryScreen extends StatefulWidget {
  const EarnTopUpOrderSummaryScreen({
    super.key,
    required this.earnPosition,
    required this.amount,
  });

  final EarnPositionClientModel earnPosition;
  final Decimal amount;

  @override
  State<EarnTopUpOrderSummaryScreen> createState() => _EarnTopUpOrderSummaryScreenState();
}

class _EarnTopUpOrderSummaryScreenState extends State<EarnTopUpOrderSummaryScreen> {
  @override
  void initState() {
    sAnalytics.earnDepositOrderSummaryScreenView(
      assetName: widget.earnPosition.offers.first.assetId,
      earnAPYrate: widget.earnPosition.offers.first.apyRate?.toString() ?? Decimal.zero.toString(),
      earnDepositAmount: widget.amount.toString(),
      earnPlanName: widget.earnPosition.offers.first.description ?? '',
      earnWithdrawalType: widget.earnPosition.offers.first.withdrawType.name,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Provider<EarnTopUpOrderSummaryStore>(
      create: (context) => EarnTopUpOrderSummaryStore(
        earnPosition: widget.earnPosition,
        amount: widget.amount,
      ),
      builder: (context, child) {
        final store = EarnTopUpOrderSummaryStore.of(context);

        return SPageFrameWithPadding(
          loading: store.loader,
          loaderText: intl.register_pleaseWait,
          customLoader: store.showProcessing ? const WaitingScreen() : null,
          header: SSmallHeader(
            title: intl.earn_order_summary,
            subTitle: intl.about_transfer,
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
    final store = EarnTopUpOrderSummaryStore.of(context);
    final isBalanceHide = getIt<AppStore>().isBalanceHide;

    return Observer(
      builder: (context) {
        return CustomScrollView(
          physics: const ClampingScrollPhysics(),
          shrinkWrap: true,
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WhatToWhatConvertWidget(
                    isLoading: false,
                    fromAssetIconUrl: store.currency.iconUrl,
                    fromAssetDescription: intl.earn_crypto_wallet,
                    fromAssetValue: isBalanceHide
                        ? '**** ${store.currency.symbol}'
                        : store.selectedAmount.toFormatCount(
                            symbol: store.currency.symbol,
                          ),
                    fromAssetBaseAmount: isBalanceHide
                        ? '**** ${sSignalRModules.baseCurrency.symbol}'
                        : '≈${store.baseAmount.toFormatCount(symbol: store.fiatSymbol, accuracy: store.eurCurrency.accuracy)}',
                    toAssetIconUrl: store.currency.iconUrl,
                    toAssetDescription: intl.earn_earn,
                    toAssetValue: isBalanceHide
                        ? '**** ${store.currency.symbol}'
                        : store.selectedAmount.toFormatCount(
                            symbol: store.currency.symbol,
                          ),
                    toAssetBaseAmount: isBalanceHide
                        ? '**** ${sSignalRModules.baseCurrency.symbol}'
                        : '≈${store.baseAmount.toFormatCount(symbol: store.fiatSymbol, accuracy: store.eurCurrency.accuracy)}',
                  ),
                  const SDivider(),
                  const SizedBox(height: 19),
                  TwoColumnCell(
                    label: intl.to1,
                    value: store.offer.name,
                    needHorizontalPadding: false,
                  ),
                  if (store.offer.apyRate != null)
                    TwoColumnCell(
                      label: intl.earn_apy_rate,
                      value: ((store.offer.apyRate ?? Decimal.zero) * Decimal.fromInt(100)).toFormatPercentCount(),
                      needHorizontalPadding: false,
                    ),
                  TwoColumnCell(
                    label: intl.earn_earning_term,
                    value: store.offer.withdrawType == WithdrawType.instant
                        ? intl.earn_flexible
                        : intl.earn_freeze_days(store.offer.lockPeriod ?? 0),
                    needHorizontalPadding: false,
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
                          assetName: store.earnPosition.offers.first.assetId,
                          earnAPYrate: store.earnPosition.offers.first.apyRate?.toString() ?? Decimal.zero.toString(),
                          earnDepositAmount: store.amount.toString(),
                          earnPlanName: store.earnPosition.offers.first.description ?? '',
                          earnWithdrawalType: store.earnPosition.offers.first.withdrawType.name,
                        );
                        store.confirm();
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
