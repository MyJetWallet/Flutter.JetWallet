import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/earn/store/earn_withdrawal_order_summary_store.dart';
import 'package:jetwallet/features/wallet/helper/format_date_to_hm.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model_new.dart';

@RoutePage(name: 'EarnWithdrawOrderSummaryRouter')
class EarnWithdrawOrderSummaryScreen extends StatelessWidget {
  const EarnWithdrawOrderSummaryScreen({
    super.key,
    required this.earnPosition,
    required this.amount,
    this.isClosing = false,
  });

  final EarnPositionClientModel earnPosition;
  final Decimal amount;
  final bool isClosing;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Provider<EarnWithdrawalOrderSummaryStore>(
      create: (context) => EarnWithdrawalOrderSummaryStore(
        earnPosition: earnPosition,
        amount: amount,
        isClosing: isClosing,
      ),
      builder: (context, child) {
        final store = EarnWithdrawalOrderSummaryStore.of(context);

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
            subTitle: intl.earn_send,
            subTitleStyle: sBodyText2Style.copyWith(
              color: colors.grey1,
            ),
          ),
          child: const _EarnWithdrawOrderSummaruBody(),
        );
      },
    );
  }
}

class _EarnWithdrawOrderSummaruBody extends StatelessWidget {
  const _EarnWithdrawOrderSummaruBody();

  @override
  Widget build(BuildContext context) {
    final store = EarnWithdrawalOrderSummaryStore.of(context);
    final isBalanceHide = getIt<AppStore>().isBalanceHide;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WhatToWhatConvertWidget(
          isLoading: false,
          fromAssetIconUrl: store.currency.iconUrl,
          fromAssetDescription: intl.earn_earn,
          fromAssetValue: isBalanceHide
              ? '**** ${store.currency.symbol}'
              : volumeFormat(decimal: store.amount, symbol: store.currency.symbol),
          fromAssetBaseAmount: isBalanceHide
              ? '**** ${sSignalRModules.baseCurrency.symbol}'
              : '≈${volumeFormat(decimal: store.baseAmount, symbol: sSignalRModules.baseCurrency.symbol, accuracy: store.baseCurrency.accuracy)}',
          toAssetIconUrl: store.currency.iconUrl,
          toAssetDescription: intl.earn_crypto_wallet,
          toAssetValue: isBalanceHide
              ? '**** ${store.currency.symbol}'
              : volumeFormat(decimal: store.amount, symbol: store.currency.symbol),
          toAssetBaseAmount: isBalanceHide
              ? '**** ${sSignalRModules.baseCurrency.symbol}'
              : '≈${volumeFormat(decimal: store.baseAmount, symbol: sSignalRModules.baseCurrency.symbol, accuracy: store.baseCurrency.accuracy)}',
        ),
        const SDivider(),
        const SizedBox(height: 19),
        TwoColumnCell(
          label: intl.from,
          value: store.earnPosition.offers.first.name,
          needHorizontalPadding: false,
        ),
        if (store.isClosing) ...[
          TwoColumnCell(
            label: intl.earn_basis_amount,
            value: isBalanceHide
                ? '**** ${store.currency.symbol}'
                : volumeFormat(decimal: store.earnPosition.baseAmount, symbol: store.currency.symbol),
            needHorizontalPadding: false,
          ),
          TwoColumnCell(
            label: intl.earn_revenue,
            value: isBalanceHide
                ? '**** ${store.currency.symbol}'
                : volumeFormat(decimal: store.earnPosition.incomeAmount, symbol: store.currency.symbol),
            needHorizontalPadding: false,
          ),
        ],
        const SizedBox(height: 7),
        ProcessingFeeRowWidget(
          fee: '0 ${store.currency.symbol}',
        ),
        const SizedBox(height: 7),
        if (store.earnPosition.withdrawType == WithdrawType.lock)
          TwoColumnCell(
            label: intl.earn_withdrawal_period,
            value: '${store.earnPosition.offers.first.lockPeriod} ${intl.days}',
            needHorizontalPadding: false,
            haveInfoIcon: true,
            onTab: () {
              _showWithdrawalPeriodExplanation(
                context: context,
                countOfDays: store.earnPosition.offers.first.lockPeriod ?? 1,
              );
            },
          ),
        const SizedBox(height: 16),
        if (store.earnPosition.withdrawType == WithdrawType.lock)
          Builder(
            builder: (context) {
              final closeDate = DateTime.now().add(Duration(days: store.earnPosition.offers.first.lockPeriod ?? 0));
              final formatedData = formatDateToDMYFromDate(closeDate.toString());

              final days = store.earnPosition.offers.first.lockPeriod ?? 1;
              return Text(
                intl.earn_the_funds_will_be_disbursed(formatedData, days),
                style: sCaptionTextStyle.copyWith(
                  color: SColorsLight().gray8,
                ),
                maxLines: 5,
              );
            },
          )
        else if (!store.isClosing)
          Text(
            intl.earn_order_summary_partial_withdrawal_means,
            style: sCaptionTextStyle.copyWith(
              color: SColorsLight().gray8,
            ),
            maxLines: 5,
          ),
        const SizedBox(height: 16),
        const SDivider(),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: SPrimaryButton2(
            active: true,
            name: intl.previewBuyWithAsset_confirm,
            onTap: () {
              store.confirm();
            },
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  void _showWithdrawalPeriodExplanation({
    required BuildContext context,
    required int countOfDays,
  }) {
    sShowBasicModalBottomSheet(
      context: context,
      horizontalPinnedPadding: 24,
      scrollable: true,
      pinned: SBottomSheetHeader(
        name: intl.earn_withdrawal_period,
      ),
      children: [
        SPaddingH24(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                intl.earn_withdrawal_period_explanation_1(countOfDays),
                maxLines: 10,
                style: sBodyText1Style.copyWith(
                  color: sKit.colors.grey2,
                ),
              ),
              const SpaceH12(),
              Text(
                intl.earn_withdrawal_period_explanation_2,
                maxLines: 10,
                style: sBodyText1Style.copyWith(
                  color: sKit.colors.grey2,
                ),
              ),
              const SpaceH64(),
            ],
          ),
        ),
      ],
    );
  }
}
