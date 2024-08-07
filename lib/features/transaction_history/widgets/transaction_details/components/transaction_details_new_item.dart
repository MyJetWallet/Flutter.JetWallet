import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';
import '../../../../../core/l10n/i10n.dart';
import 'transaction_details_name_text.dart';

class TransactionDetailsNewItem extends StatelessWidget {
  const TransactionDetailsNewItem({
    super.key,
    this.fromStart = false,
    this.showInfoIcon = false,
    this.fee,
    required this.text,
    required this.value,
  });

  final String text;
  final String? fee;
  final Widget value;
  final bool fromStart;
  final bool showInfoIcon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: fromStart ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          TransactionDetailsNameText(
            text: text,
          ),
          if (showInfoIcon) ...[
            const SpaceW5(),
            GestureDetector(
              onTap: () {
                _feeExplanation(
                  context: context,
                  title: intl.buy_confirmation_payment_fee,
                  fee: fee!,
                  description: intl.buy_confirmation_payment_fee_description,
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
          ],
          const Spacer(),
          value,
        ],
      ),
    );
  }

  void _feeExplanation({
    required BuildContext context,
    required String title,
    required String fee,
    required String description,
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
}
