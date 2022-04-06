import '../../../../../service/services/operation_history/model/operation_history_response_model.dart';

String operationName(OperationType type) {
  switch (type) {
    case OperationType.deposit:
      return 'Deposit';
    case OperationType.withdraw:
      return 'Withdrawal';
    case OperationType.transferByPhone:
      return 'Transfer by Phone';
    case OperationType.receiveByPhone:
      return 'Receive by Phone';
    case OperationType.buy:
      return 'Buy';
    case OperationType.sell:
      return 'Sell';
    case OperationType.paidInterestRate:
      return 'Interest Rate';
    case OperationType.feeSharePayment:
      return 'Referral program fee share';
    case OperationType.swap:
      return 'Swap';
    case OperationType.withdrawalFee:
      return 'Withdrawal Fee';
    case OperationType.rewardPayment:
      return 'Referral program bonus';
    case OperationType.unknown:
      return 'Unknown';
    case OperationType.simplexBuy:
      return 'Simplex';
  }
}
