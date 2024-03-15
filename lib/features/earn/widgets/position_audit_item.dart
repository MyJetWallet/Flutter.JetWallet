import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_list_item_header_text.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/components/transaction_list_item_text.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/icons/24x24/public/history_completed/simple_history_completed_icon.dart';
import 'package:simple_kit/modules/icons/24x24/public/history_declined/simple_history_declined_icon.dart';
import 'package:simple_kit/modules/loader/simple_loader.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
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
    final colors = sKit.colors;

    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: colors.grey5,
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
                          color: status == Status.declined ? colors.grey2 : colors.black,
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
                        color: status == Status.declined ? colors.grey2 : colors.black,
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
                    color: colors.grey1,
                  ),
                  const Spacer(),
                  if (rightSupplement != null)
                    TransactionListItemText(
                      text: rightSupplement!,
                      color: colors.grey1,
                    ),
                  const SpaceW5(),
                  if (status == Status.inProgress)
                    const SimpleLoader()
                  else if (status == Status.completed)
                    const SHistoryCompletedIcon()
                  else if (status == Status.declined)
                    SHistoryDeclinedIcon(
                      color: colors.grey2,
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
