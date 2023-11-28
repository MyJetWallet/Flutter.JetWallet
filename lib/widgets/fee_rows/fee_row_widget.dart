import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';

class ProcessingFeeRowWidget extends StatelessWidget {
  const ProcessingFeeRowWidget({
    super.key,
    this.isLoaded = true,
    required this.fee,
    this.onTabListener,
  });

  final bool isLoaded;
  final String fee;
  final void Function()? onTabListener;

  @override
  Widget build(BuildContext context) {
    return _BasicFeeRowWidget(
      title: intl.buy_confirmation_processing_fee,
      isLoaded: isLoaded,
      fee: fee,
      description: intl.buy_confirmation_processing_fee_description,
      onTabListener: onTabListener,
    );
  }
}

class PaymentFeeRowWidget extends StatelessWidget {
  const PaymentFeeRowWidget({
    super.key,
    this.isLoaded = true,
    required this.fee,
    this.onTabListener,
  });

  final bool isLoaded;
  final String fee;
  final void Function()? onTabListener;

  @override
  Widget build(BuildContext context) {
    return _BasicFeeRowWidget(
      title: intl.buy_confirmation_payment_fee,
      isLoaded: isLoaded,
      fee: fee,
      description: intl.buy_confirmation_payment_fee_description,
      onTabListener: onTabListener,
    );
  }
}

class _BasicFeeRowWidget extends StatelessWidget {
  const _BasicFeeRowWidget({
    required this.isLoaded,
    required this.fee,
    required this.title,
    required this.description,
    this.onTabListener,
  });

  final bool isLoaded;
  final String fee;
  final String title;
  final String description;
  final void Function()? onTabListener;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return InkWell(
      onTap: () {
        _showFeeExplanation(
          context: context,
        );
        
        onTabListener?.call();
      },
      child: Material(
        color: colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: sBodyText2Style.copyWith(color: colors.grey1),
            ),
            const SpaceW5(),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: SizedBox(
                width: 16,
                height: 16,
                child: SInfoIcon(color: colors.grey1),
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
        ),
      ),
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
  }) {
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
              const SpaceH19(),
              Text(
                fee,
                style: sTextH3Style,
              ),
              const SpaceH9(),
              const SDivider(),
              const SpaceH22(),
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
}
