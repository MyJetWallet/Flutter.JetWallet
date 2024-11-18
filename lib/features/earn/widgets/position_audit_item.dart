import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item_header_text.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item_text.dart';
import 'package:simple_kit/modules/icons/24x24/public/history_completed/simple_history_completed_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/history_declined/simple_history_declined_icon.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

class PositionAuditItem extends StatelessWidget {
  const PositionAuditItem({
    required this.onTap,
    required this.icon,
    required this.labele,
    this.labelIcon,
    required this.balanceChange,
    required this.status,
    required this.timeStamp,
    this.rightSupplement,
    super.key,
  });

  final void Function() onTap;
  final Widget icon;
  final String labele;
  final Widget? labelIcon;
  final String balanceChange;
  final Status status;
  final String timeStamp;
  final String? rightSupplement;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: colors.gray2,
      hoverColor: Colors.transparent,
      child: SPaddingH24(
        child: SizedBox(
          height: 80,
          child: Column(
            children: [
              const SpaceH12(),
              Row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: icon,
                  ),
                  const SpaceW10(),
                  Expanded(
                    child: Row(
                      children: [
                        TransactionListItemHeaderText(
                          text: labele,
                          color: status == Status.declined ? colors.gray8 : colors.black,
                        ),
                        if (labelIcon != null) ...[
                          Padding(
                            padding: const EdgeInsets.only(left: 4, top: 1.5),
                            child: SizedBox(
                              height: 16,
                              child: labelIcon,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Container(
                    constraints: const BoxConstraints(
                      maxWidth: 220,
                      minWidth: 100,
                    ),
                    child: AutoSizeText(
                      balanceChange,
                      textAlign: TextAlign.end,
                      minFontSize: 4.0,
                      maxLines: 1,
                      strutStyle: const StrutStyle(
                        height: 1.56,
                        fontSize: 18.0,
                        fontFamily: 'Gilroy',
                      ),
                      style: TextStyle(
                        height: 1.56,
                        fontSize: 18.0,
                        fontFamily: 'Gilroy',
                        fontWeight: FontWeight.w600,
                        color: status == Status.declined ? colors.gray8 : colors.black,
                        decoration: status == Status.declined ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const SpaceW34(),
                  TransactionListItemText(
                    text: timeStamp,
                    color: colors.gray10,
                  ),
                  const Spacer(),
                  if (rightSupplement != null)
                    TransactionListItemText(
                      text: rightSupplement!,
                      color: colors.gray10,
                    ),
                  const SpaceW5(),
                  if (status == Status.inProgress)
                    const SimpleLoader()
                  else if (status == Status.completed)
                    const SHistoryCompletedIcon()
                  else if (status == Status.declined)
                    SHistoryDeclinedIcon(
                      color: colors.gray8,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
