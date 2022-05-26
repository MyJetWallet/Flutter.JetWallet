import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/operation_history/model/operation_history_response_model.dart';

import '../../wallet/notifier/operation_history_notipod.dart';
import '../../wallet/provider/operation_history_fpod.dart';

final ordersPod = Provider.autoDispose<List<OperationHistoryItem>>((ref) {
  final initTransactionHistory = ref.watch(operationHistoryInitFpod(null));
  final transactionHistory = ref.watch(
    operationHistoryNotipod(
      null,
    ),
  );

  var orders = <OperationHistoryItem>[];

  initTransactionHistory.whenData((data) {
    final transactions = transactionHistory.operationHistoryItems;
    orders = transactions
        .where(
          (transaction) =>
              transaction.operationType == OperationType.buy ||
              transaction.operationType == OperationType.sell,
        )
        .toList();
  });

  return orders;
});
