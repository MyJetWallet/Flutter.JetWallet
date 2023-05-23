import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/features/wallet/ui/widgets/transaction_item.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

void showTransactionDetails(
  BuildContext context,
  OperationHistoryItem transactionListItem,
  Function(dynamic)? then,
) {
  sShowBasicModalBottomSheet(
    children: [
      TransactionItem(
        transactionListItem: transactionListItem,
      ),
    ],
    context: context,
    then: then,
  );
}
