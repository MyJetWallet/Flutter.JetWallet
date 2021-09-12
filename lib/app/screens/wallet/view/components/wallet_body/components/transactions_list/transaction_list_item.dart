import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../shared/components/spacers.dart';
import '../../../../../provider/hidden_state_provider.dart';

class TransactionListItem extends HookWidget {
  const TransactionListItem({
    Key? key,
    required this.transactionListItem,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final hidden = useProvider(hiddenStatePod);

    return SizedBox(
      height: 80.h,
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                _icon(transactionListItem.operationType),
                size: 20.r,
              ),
              const SpaceW10(),
              Text(
                _operationName(transactionListItem.operationType),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              ),
              const Spacer(),
              Text(
                '\$${hidden.state ? '???' : transactionListItem.balanceChange}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18.sp,
                ),
              )
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 20.r,
              ),
              const SpaceW10(),
              Text(
                DateFormat('Hm').format(
                  // Temporary. Will be fixed in next PR
                  // TODO(Vova):
                  // DateTime.parse('${transactionListItem.timeStamp}Z')
                  // .toLocal(),
                  DateTime.parse(transactionListItem.timeStamp).toLocal(),
                ),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.sp,
                ),
              ),
              const Spacer(),
              // Temporary. Wil lbe fxined in next PR
              // TODO(Vova): Add asset balance change for buy+sell
              // Text(
              //   'With ${'${hidden.state
              //       ? '???'
              //       : transactionListItem.balanceChange}'} '
              //   '${transactionListItem.assetId}',
              //   style: TextStyle(
              //     color: Colors.grey,
              //     fontSize: 16.sp,
              //   ),
              // )
            ],
          ),
          const SpaceH10(),
          const Divider(),
        ],
      ),
    );
  }

  IconData _icon(OperationType type) {
    switch (type) {
      case OperationType.deposit:
        return FontAwesomeIcons.creditCard;
      case OperationType.withdraw:
        return Icons.arrow_forward;
      case OperationType.swap:
        // TODO(Vova): Handle this case.
      case OperationType.withdrawalFee:
      return FontAwesomeIcons.question;
      case OperationType.transferByPhone:
        return Icons.arrow_upward;
      case OperationType.receiveByPhone:
        return Icons.arrow_downward;
      case OperationType.unknown:
        return FontAwesomeIcons.question;
    }
  }

  String _operationName(OperationType type) {
    switch (type) {
      case OperationType.deposit:
        return 'Deposit';
      case OperationType.withdraw:
        return 'Withdraw';
      case OperationType.swap:
      // TODO(Vova): Handle this case.
      case OperationType.withdrawalFee:
        return 'WithdrawalFee';
      case OperationType.transferByPhone:
        return 'Transfer by Phone';
      case OperationType.receiveByPhone:
        return 'Receive by Phone';
      case OperationType.unknown:
        return 'Unknown';
    }
  }
}
