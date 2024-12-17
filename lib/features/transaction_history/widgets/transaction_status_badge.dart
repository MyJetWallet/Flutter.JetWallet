import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_details/components/transaction_details_status.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

class TransactionStatusBadge extends StatelessWidget {
  const TransactionStatusBadge({super.key, required this.status});

  final Status status;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return SBadge(
      lable: transactionDetailsStatusText(status),
      type: status == Status.inProgress
          ? SBadgeType.neutral
          : status == Status.completed
              ? SBadgeType.positive
              : SBadgeType.negative,
      icon: status == Status.inProgress
          ? SimpleLoader(
              strokeWidth: 3,
              color: colors.blue,
            )
          : status == Status.completed
              ? Assets.svg.medium.checkmarkAlt.simpleSvg(
                  color: colors.green,
                  width: 20,
                )
              : Assets.svg.medium.closeAlt.simpleSvg(
                  color: colors.red,
                  width: 20,
                ),
    );
  }
}
