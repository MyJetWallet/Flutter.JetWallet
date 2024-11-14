import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_item.dart';
import 'package:jetwallet/features/transaction_history/widgets/transaction_list_item.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

void showTransactionDetails({
  required BuildContext context,
  required OperationHistoryItem transactionListItem,
  Function(dynamic)? then,
  TransactionItemSource source = TransactionItemSource.history,
}) {
  showBasicBottomSheet(
    children: [
      TransactionItem(
        transactionListItem: transactionListItem,
        source: source,
      ),
    ],
    context: context,
  ).then((v) {
    then?.call(v);
  });
}
