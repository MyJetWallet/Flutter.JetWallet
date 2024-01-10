import 'package:flutter/material.dart';
import 'package:jetwallet/widgets/fee_rows/fee_row_widget.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';

class TransferConfirmationInfoGrid extends StatelessWidget {
  const TransferConfirmationInfoGrid({
    super.key,
    required this.isDataLoaded,
    required this.isToCard,
    required this.sendToLable,
    required this.benificiary,
    required this.reference,
    required this.paymentFee,
    required this.processingFee,
  });

  final bool isDataLoaded;
  final bool isToCard;

  final String sendToLable;
  final String benificiary;
  final String reference;
  final String paymentFee;
  final String processingFee;

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SDivider(),
        const SizedBox(height: 19),
        SizedBox(
          height: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Send to',
                style: sBodyText2Style.copyWith(color: sKit.colors.grey1),
              ),
              if (isDataLoaded) ...[
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const SpaceW19(),
                      if (isToCard)
                        Assets.svg.assets.fiat.cardAlt.simpleSvg(
                          width: 24,
                        )
                      else
                        Assets.svg.other.medium.bankAccount.simpleSvg(
                          width: 24,
                        ),
                      const SpaceW8(),
                      Flexible(
                        child: Text(
                          sendToLable,
                          overflow: TextOverflow.ellipsis,
                          style: sSubtitle3Style.copyWith(height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                textPreloader(),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (isDataLoaded && benificiary.trim().isNotEmpty) ...[
          _FieldRowWidget(
            lable: 'Benificiary',
            value: benificiary,
            isDataLoaded: isDataLoaded,
          ),
          const SizedBox(height: 16),
        ],
        _FieldRowWidget(
          lable: 'Reference',
          value: reference,
          isDataLoaded: isDataLoaded,
        ),
        const SizedBox(height: 16),
        PaymentFeeRowWidget(
          fee: paymentFee,
          isLoaded: isDataLoaded,
          onTabListener: () {
            sAnalytics.paymentProcessingFeeSellPopupView(
              feeType: FeeType.payment,
            );
          },
        ),
        const SizedBox(height: 16),
        ProcessingFeeRowWidget(
          fee: processingFee,
          isLoaded: isDataLoaded,
          onTabListener: () {
            sAnalytics.paymentProcessingFeeSellPopupView(
              feeType: FeeType.processing,
            );
          },
        ),
        const SizedBox(height: 19),
      ],
    );
  }
}

class _FieldRowWidget extends StatelessWidget {
  const _FieldRowWidget({
    required this.lable,
    required this.value,
    required this.isDataLoaded,
  });

  final bool isDataLoaded;

  final String lable;
  final String value;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            lable,
            style: sBodyText2Style.copyWith(color: sKit.colors.grey1),
          ),
          if (isDataLoaded) ...[
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      style: sSubtitle3Style.copyWith(height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            textPreloader(),
          ],
        ],
      ),
    );
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
}
