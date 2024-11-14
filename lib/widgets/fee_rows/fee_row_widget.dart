import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class ProcessingFeeRowWidget extends StatelessWidget {
  const ProcessingFeeRowWidget({
    super.key,
    this.isLoaded = true,
    required this.fee,
    this.onTabListener,
    this.onBotomSheetClose,
    this.needPadding = false,
  });

  final bool isLoaded;
  final String fee;
  final void Function()? onTabListener;
  final dynamic Function(dynamic)? onBotomSheetClose;
  final bool needPadding;

  @override
  Widget build(BuildContext context) {
    return _BasicFeeRowWidget(
      title: intl.buy_confirmation_processing_fee,
      isLoaded: isLoaded,
      fee: fee,
      description: intl.buy_confirmation_processing_fee_description,
      onTabListener: onTabListener,
      onBotomSheetClose: onBotomSheetClose,
      needPadding: needPadding,
    );
  }
}

class PaymentFeeRowWidget extends StatelessWidget {
  const PaymentFeeRowWidget({
    super.key,
    this.isLoaded = true,
    required this.fee,
    this.onTabListener,
    this.onBotomSheetClose,
  });

  final bool isLoaded;
  final String fee;
  final void Function()? onTabListener;
  final dynamic Function(dynamic)? onBotomSheetClose;

  @override
  Widget build(BuildContext context) {
    return _BasicFeeRowWidget(
      title: intl.provider_fee,
      isLoaded: isLoaded,
      fee: fee,
      description: intl.buy_confirmation_payment_fee_description,
      onTabListener: onTabListener,
      onBotomSheetClose: onBotomSheetClose,
      needPadding: false,
    );
  }
}

class _BasicFeeRowWidget extends StatelessWidget {
  const _BasicFeeRowWidget({
    required this.isLoaded,
    required this.fee,
    required this.title,
    required this.description,
    required this.needPadding,
    this.onTabListener,
    this.onBotomSheetClose,
  });

  final bool isLoaded;
  final String fee;
  final String title;
  final String description;
  final void Function()? onTabListener;
  final dynamic Function(dynamic)? onBotomSheetClose;
  final bool needPadding;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Padding(
      padding: needPadding ? const EdgeInsets.symmetric(vertical: 8) : EdgeInsets.zero,
      child: InkWell(
        onTap: () {
          _showFeeExplanation(
            context: context,
            then: onBotomSheetClose,
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
                style: STStyles.body2Medium.copyWith(color: colors.grey1),
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
                  style: STStyles.subtitle2,
                ),
              ] else ...[
                _textPreloader(),
              ],
            ],
          ),
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
    dynamic Function(dynamic)? then,
  }) {
    showBasicBottomSheet(
      context: context,
      header: BasicBottomSheetHeaderWidget(
        title: title,
      ),
      children: [
        SPaddingH24(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpaceH19(),
              Text(
                fee,
                style: STStyles.header4,
              ),
              const SpaceH9(),
              const SDivider(),
              const SpaceH22(),
              Text(
                description,
                maxLines: 3,
                style: STStyles.captionMedium.copyWith(
                  color: sKit.colors.grey2,
                ),
              ),
              const SpaceH64(),
            ],
          ),
        ),
      ],
    ).then((v) {
      then?.call(v);
    });
  }
}
