import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../../../../shared/components/spacers.dart';

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
        Text(
          'Status',
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ),
        const Spacer(),
        Icon(_icon()),
        const SpaceW8(),
        Text(
          _text(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
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
