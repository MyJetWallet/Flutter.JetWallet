import '../../../../../service/services/operation_history/model/operation_history_response_model.dart';

String operationName(OperationType type) {
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
    case OperationType.paidInterestRate:
    case OperationType.transfer:
    case OperationType.feeSharePayment:
    case OperationType.swap:
    case OperationType.withdrawalFee:
    case OperationType.unknown:
      return 'Unknown';
  }
}
