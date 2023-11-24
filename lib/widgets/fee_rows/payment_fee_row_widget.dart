import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class PaymentFeeRowWidget extends StatelessWidget {
  const PaymentFeeRowWidget({
    super.key,
    this.isLoaded = true,
    required this.fee,
  });

  final bool isLoaded;
  final String fee;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          intl.buy_confirmation_payment_fee,
          style: sBodyText2Style.copyWith(color: sKit.colors.grey1),
        ),
        const SpaceW5(),
        GestureDetector(
          onTap: () {
            _showFeeExplanation(
              context: context,
              fee: fee,
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
        if (isLoaded) ...[
          Text(
            fee,
            style: sSubtitle3Style,
          ),
        ] else ...[
          _textPreloader(),
        ],
      ],
    );
  }

  Widget _textPreloader() {
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

  void _showFeeExplanation({
    required BuildContext context,
    required String fee,
  }) {
    sShowBasicModalBottomSheet(
      context: context,
      horizontalPinnedPadding: 24,
      scrollable: true,
      pinned: SBottomSheetHeader(
        name: intl.buy_confirmation_payment_fee,
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
                intl.buy_confirmation_payment_fee_description,
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
}
