import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/buy_flow/store/convert_confirmation_store.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';

class ConvertConfirmationInfoGrid extends StatefulObserverWidget {
  const ConvertConfirmationInfoGrid({
    super.key,
    this.ourFee,
    required this.totalValue,
    required this.paymentCurrency,
    required this.asset,
  });

  final String? ourFee;

  final String totalValue;
  final CurrencyModel paymentCurrency;
  final CurrencyModel asset;

  @override
  State<ConvertConfirmationInfoGrid> createState() => _ConfirmationInfoGridState();
}

class _ConfirmationInfoGridState extends State<ConvertConfirmationInfoGrid> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this);

    final store = ConvertConfirmationStore.of(context);

    store.updateTimerAnimation(_animationController);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget textPreloader() {
    return Baseline(
      baseline: 19.0,
      baselineType: TextBaseline.alphabetic,
      child: SSkeletonTextLoader(
        height: 24,
        width: 120,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = ConvertConfirmationStore.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SDivider(),
        const SizedBox(height: 19),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              intl.buy_confirmation_price,
              style: sBodyText2Style.copyWith(color: sKit.colors.grey1),
            ),
            const Spacer(),
            if (store.isDataLoaded) ...[
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Baseline(
                  baseline: 16,
                  baselineType: TextBaseline.alphabetic,
                  child: SConfirmActionTimer(
                    animation: store.timerAnimation!,
                    loading: store.timerLoading,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${volumeFormat(
                  accuracy: widget.asset.accuracy,
                  decimal: Decimal.one,
                  symbol: widget.asset.symbol,
                )} = ${volumeFormat(
                  accuracy: store.rate?.scale ?? 0,
                  decimal: store.rate ?? Decimal.zero,
                  symbol: widget.paymentCurrency.symbol,
                )}',
                style: sSubtitle3Style,
              ),
            ] else ...[
              textPreloader(),
            ],
          ],
        ),
        const SizedBox(height: 16),
        if (widget.ourFee != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                intl.buy_confirmation_processing_fee,
                style: sBodyText2Style.copyWith(color: sKit.colors.grey1),
              ),
              const SpaceW5(),
              GestureDetector(
                onTap: () {
                  sAnalytics.newBuyTapPaymentFee();

                  buyConfirmationFeeExplanation(
                    context: context,
                    title: intl.buy_confirmation_processing_fee,
                    fee: widget.ourFee ?? '',
                    description: intl.buy_confirmation_processing_fee_description,
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: SInfoIcon(color: sKit.colors.grey1),
                  ),
                ),
              ),
              const Spacer(),
              if (store.isDataLoaded) ...[
                Text(
                  widget.ourFee ?? '',
                  style: sSubtitle3Style,
                ),
              ] else ...[
                textPreloader(),
              ],
            ],
          ),
        ],
        const SizedBox(height: 19),
        const SDivider(),
      ],
    );
  }
}

void buyConfirmationFeeExplanation({
  required BuildContext context,
  required String title,
  required String fee,
  required String description,
}) {
  sAnalytics.newBuyFeeView(paymentFee: fee);

  sShowBasicModalBottomSheet(
    context: context,
    horizontalPinnedPadding: 24,
    scrollable: true,
    pinned: SBottomSheetHeader(
      name: title,
    ),
    children: [
      SPaddingH24(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SpaceH16(),
            Text(
              fee,
              style: sTextH4Style,
            ),
            const SpaceH12(),
            const SDivider(),
            const SpaceH12(),
            Text(
              description,
              maxLines: 3,
              style: sCaptionTextStyle.copyWith(
                color: sKit.colors.grey3,
              ),
            ),
            const SpaceH64(),
          ],
        ),
      ),
    ],
  );
}
