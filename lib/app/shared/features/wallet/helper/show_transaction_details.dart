import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/operation_history/model/operation_history_response_model.dart';

import '../view/components/transaction_item.dart';

void showTransactionDetails(
  BuildContext context,
  OperationHistoryItem transactionListItem,
) {
  sShowBasicModalBottomSheet(
    children: [
      TransactionItem(
        transactionListItem: transactionListItem,
      )
    ],
    context: context,
  );
}
