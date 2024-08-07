import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';
import 'transaction_details_name_text.dart';
import 'transaction_details_value_text.dart';

class TransactionDetailsStatus extends StatelessObserverWidget {
  const TransactionDetailsStatus({
    super.key,
    this.reason,
    required this.status,
  });

  final Status status;
  final String? reason;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return Row(
      children: [
        TransactionDetailsNameText(
          text: intl.transactionDetailsStatus_status,
        ),
        const Spacer(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TransactionDetailsValueText(
              text: _text(context),
              color: _color(colors),
            ),
            if (reason != null && status == Status.declined)
              Text(
                reason!,
                maxLines: 2,
                style: const TextStyle(
                  color: Color(0xFFFB9BAF),
                  fontSize: 12,
                  fontFamily: 'Gilroy',
                  fontWeight: FontWeight.w500,
                ),
              ),
          ],
        ),
      ],
    );
  }

  String _text(BuildContext context) {
    switch (status) {
      case Status.completed:
        return intl.transactionDetailsStatus_completed;
      case Status.inProgress:
        return '${intl.transactionDetailsStatus_balanceInProcess}...';
      case Status.declined:
        return intl.transactionDetailsStatus_declined;
    }
  }

  Color _color(SimpleColors colors) {
    switch (status) {
      case Status.completed:
        return colors.green;
      case Status.inProgress:
        return colors.grey1;
      case Status.declined:
        return colors.red;
    }
  }
}

String transactionDetailsStatusText(Status status, {bool isPending = false}) {
  switch (status) {
    case Status.completed:
      return intl.transactionDetailsStatus_completed;
    case Status.inProgress:
      return isPending ? intl.transactionDetailsStatus_pending : intl.transactionDetailsStatus_balanceInProcess;
    case Status.declined:
      return intl.transactionDetailsStatus_declined;
  }
}
