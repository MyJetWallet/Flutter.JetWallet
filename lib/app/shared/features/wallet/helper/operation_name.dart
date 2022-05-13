import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/operation_history/model/operation_history_response_model.dart';
import '../../../../../shared/providers/service_providers.dart';

String operationName(OperationType type, BuildContext context,) {
  final intl = context.read(intlPod);

  switch (type) {
    case OperationType.deposit:
      return intl.deposit;
    case OperationType.withdraw:
      return intl.withdrawal;
    case OperationType.transferByPhone:
      return intl.transferByPhone;
    case OperationType.receiveByPhone:
      return intl.receiveByPhone;
    case OperationType.buy:
      return intl.buy;
    case OperationType.sell:
      return intl.sell;
    case OperationType.paidInterestRate:
      return intl.interestRate;
    case OperationType.feeSharePayment:
      return intl.feeSharePayment;
    case OperationType.swap:
      return intl.swap;
    case OperationType.withdrawalFee:
      return intl.withdrawalFee;
    case OperationType.rewardPayment:
      return intl.rewardPayment;
    case OperationType.simplexBuy:
      return intl.simplex;
    case OperationType.recurringBuy:
      return intl.account_recurringBuy;
    case OperationType.unknown:
      return 'Unknown';
  }
}
