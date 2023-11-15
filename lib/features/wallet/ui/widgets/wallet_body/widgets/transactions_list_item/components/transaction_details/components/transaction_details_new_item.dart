import 'package:flutter/material.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/public/info/simple_info_icon.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import '../../../../../../../../../../core/l10n/i10n.dart';
import '../../../../../../../../../buy_flow/ui/widgets/confirmation_widgets/confirmation_info_grid.dart';
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
        crossAxisAlignment:
        fromStart ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          TransactionDetailsNameText(
            text: text,
          ),
          if (showInfoIcon) ...[
            const SpaceW5(),
            GestureDetector(
              onTap: () {
                buyConfirmationFeeExplanation(
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
}
