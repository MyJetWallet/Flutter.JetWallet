import 'package:simple_networking/services/operation_history/model/operation_history_response_model.dart';

bool isOperationSupportCopy(OperationHistoryItem item) {
  return item.operationType != OperationType.paidInterestRate &&
      item.operationType != OperationType.rewardPayment &&
      item.operationType != OperationType.receiveByPhone;
}
