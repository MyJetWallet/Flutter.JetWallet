import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/operation_history/model/operation_history_response_model.dart';

import '../../../../../../../../../../../../shared/providers/service_providers.dart';
import 'transaction_details_name_text.dart';
import 'transaction_details_value_text.dart';

class TransactionDetailsStatus extends HookWidget {
  const TransactionDetailsStatus({
    Key? key,
    required this.status,
  }) : super(key: key);

  final Status status;

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);

    return Row(
      children: [
        TransactionDetailsNameText(
          text: intl.transactionDetailsStatus_status,
        ),
        const Spacer(),
        TransactionDetailsValueText(
          text: _text(context),
          color: _color(colors),
        ),
      ],
    );
  }

  String _text(BuildContext context) {
    final intl = context.read(intlPod);

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
