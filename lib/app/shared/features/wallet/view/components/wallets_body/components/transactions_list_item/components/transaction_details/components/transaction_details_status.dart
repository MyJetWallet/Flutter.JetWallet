import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../../../../../shared/components/spacers.dart';
import 'transaction_details_name_text.dart';
import 'transaction_details_value_text.dart';

class TransactionDetailsStatus extends StatelessWidget {
  const TransactionDetailsStatus({
    Key? key,
    required this.status,
  }) : super(key: key);

  final Status status;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const TransactionDetailsNameText(
          text: 'Status',
        ),
        const Spacer(),
        Icon(
          _icon(),
          size: 16.r,
        ),
        const SpaceW8(),
        TransactionDetailsValueText(
          text: _text(),
        ),
      ],
    );
  }

  String _text() {
    switch (status) {
      case Status.completed:
        return 'Completed';
      case Status.inProgress:
        return 'In progress';
      case Status.declined:
        return 'Declined';
    }
  }

  IconData _icon() {
    switch (status) {
      case Status.completed:
        return Icons.done;
      case Status.inProgress:
        return FontAwesomeIcons.ellipsisH;
      case Status.declined:
        return Icons.clear;
    }
  }
}
