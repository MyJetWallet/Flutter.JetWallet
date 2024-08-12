import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_item.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

void showTransactionDetails({
  required BuildContext context,
  required OperationHistoryItem transactionListItem,
  Function(dynamic)? then,
  TransactionItemSource source = TransactionItemSource.history,
}) {
  sShowBasicModalBottomSheet(
    children: [
      TransactionItem(
        transactionListItem: transactionListItem,
        source: source,
      ),
    ],
    scrollable: true,
    context: context,
    then: then,
  );
}
