import 'package:auto_route/auto_route.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/earn/store/earn_withdrawal_order_summaru_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:jetwallet/widgets/result_screens/waiting_screen/waiting_screen.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/what_to_what_convert/what_to_what_widget.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';

@RoutePage(name: 'EarnWithdrawOrderSummaruRouter')
class EarnWithdrawOrderSummaruScreen extends StatelessWidget {
  const EarnWithdrawOrderSummaruScreen({
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

    return Provider<EarnWithdrawalOrderSummaruStore>(
      create: (context) => EarnWithdrawalOrderSummaruStore(
        earnPosition: earnPosition,
        amount: amount,
        isClosing: isClosing,
      ),
      builder: (context, child) {
        final store = EarnWithdrawalOrderSummaruStore.of(context);

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
    final store = EarnWithdrawalOrderSummaruStore.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        WhatToWhatConvertWidget(
          isLoading: false,
          fromAssetIconUrl: store.currency.iconUrl,
          fromAssetDescription: intl.earn_earn,
          fromAssetValue: volumeFormat(decimal: store.amount, symbol: store.currency.symbol),
          fromAssetBaseAmount:
              '≈${volumeFormat(decimal: store.baseAmount, symbol: store.eurCurrency.symbol, accuracy: store.eurCurrency.accuracy)}',
          toAssetIconUrl: store.currency.iconUrl,
          toAssetDescription: intl.earn_crypto_wallet,
          toAssetValue: volumeFormat(decimal: store.amount, symbol: store.currency.symbol),
          toAssetBaseAmount:
              '≈${volumeFormat(decimal: store.baseAmount, symbol: store.eurCurrency.symbol, accuracy: store.eurCurrency.accuracy)}',
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
            value: volumeFormat(decimal: store.earnPosition.baseAmount, symbol: store.currency.symbol),
            needHorizontalPadding: false,
          ),
          TwoColumnCell(
            label: intl.earn_revenue,
            value: volumeFormat(decimal: store.earnPosition.incomeAmount, symbol: store.currency.symbol),
            needHorizontalPadding: false,
          ),
        ],
        const SizedBox(height: 7),
        ProcessingFeeRowWidget(
          fee: '0 ${store.currency.symbol}',
        ),
        const SizedBox(height: 16),
        if (!store.isClosing)
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
}
