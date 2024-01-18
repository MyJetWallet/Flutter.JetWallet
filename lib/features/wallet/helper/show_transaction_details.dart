import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/features/wallet/ui/widgets/transaction_item.dart';
import 'package:jetwallet/features/wallet/ui/widgets/wallet_body/widgets/transactions_list_item/transaction_list_item.dart';
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
