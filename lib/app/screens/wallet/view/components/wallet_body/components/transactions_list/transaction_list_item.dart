import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../../../../shared/components/spacers.dart';
import '../../../../../provider/wallet_hidden_stpod.dart';
import 'components/transaction_list_item_body_text.dart';
import 'components/transaction_list_item_header_text.dart';

class TransactionListItem extends HookWidget {
  const TransactionListItem({
    Key? key,
    required this.transactionListItem,
  }) : super(key: key);

  final OperationHistoryItem transactionListItem;

  @override
  Widget build(BuildContext context) {
    final hidden = useProvider(walletHiddenStPod);

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
              TransactionListItemHeaderText(
                text: _operationName(transactionListItem.operationType),
              ),
              const Spacer(),
              TransactionListItemHeaderText(
                text:
                    '${hidden.state
                        ? '???'
                        : transactionListItem.balanceChange} ${transactionListItem.assetId}',
              ),
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
                  DateTime.parse('${transactionListItem.timeStamp}Z').toLocal(),
                ),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.sp,
                ),
              ),
              const Spacer(),
              if (transactionListItem.operationType == OperationType.sell) ...[
                TransactionListItemBodyText(
                  text:
                      'For ${'${hidden.state
                          ? '???'
                          : transactionListItem.swapInfo!.sellAmount}'} '
                      '${transactionListItem.swapInfo!.sellAssetId}',
                ),
              ],
              if (transactionListItem.operationType == OperationType.buy) ...[
                TransactionListItemBodyText(
                  text:
                      'With ${'${hidden.state
                          ? '???'
                          : transactionListItem.swapInfo!.buyAmount}'} '
                      '${transactionListItem.swapInfo!.buyAssetId}',
                ),
              ]
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
      case OperationType.transferByPhone:
        return Icons.arrow_upward;
      case OperationType.receiveByPhone:
        return Icons.arrow_downward;
      case OperationType.buy:
        return FontAwesomeIcons.plus;
      case OperationType.sell:
        return FontAwesomeIcons.minus;
      case OperationType.withdrawalFee:
      case OperationType.swap:
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
      case OperationType.transferByPhone:
        return 'Transfer by Phone';
      case OperationType.receiveByPhone:
        return 'Receive by Phone';
      case OperationType.buy:
        return 'Buy';
      case OperationType.sell:
        return 'Sell';
      case OperationType.swap:
      case OperationType.withdrawalFee:
      case OperationType.unknown:
        return 'Unknown';
    }
  }
}
