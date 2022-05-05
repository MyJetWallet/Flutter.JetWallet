import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/operation_history/model/operation_history_response_model.dart';

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
    final colors = useProvider(sColorPod);

    return Row(
      children: [
        const TransactionDetailsNameText(
          text: 'Status',
        ),
        const Spacer(),
        TransactionDetailsValueText(
          text: _text(),
          color: _color(colors),
        ),
      ],
    );
  }

  String _text() {
    switch (status) {
      case Status.completed:
        return 'Completed';
      case Status.inProgress:
        return 'In progress...';
      case Status.declined:
        return 'Declined';
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
