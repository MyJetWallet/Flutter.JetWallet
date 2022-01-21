import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../wallet/notifier/operation_history_notipod.dart';
import '../../wallet/provider/operation_history_fpod.dart';

final transfersPod = Provider.autoDispose<List<OperationHistoryItem>>((ref) {
  final initTransactionHistory = ref.watch(
    operationHistoryInitFpod(
      null,
    ),
  );
  final transactionHistory = ref.watch(
    operationHistoryNotipod(
      null,
    ),
  );

  var transfers = <OperationHistoryItem>[];

  initTransactionHistory.whenData((data) {
    final transactions = transactionHistory.operationHistoryItems;
    transfers = transactions
        .where(
          (transaction) =>
              transaction.operationType == OperationType.deposit ||
              transaction.operationType == OperationType.withdraw ||
              transaction.operationType == OperationType.transferByPhone,
        )
        .toList();
  });

  return transfers;
});
