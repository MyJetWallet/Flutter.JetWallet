import 'package:simple_networking/modules/wallet_api/models/operation_history/operation_history_response_model.dart';

bool isOperationSupportCopy(OperationHistoryItem item) {
  return item.operationType != OperationType.paidInterestRate;
}
