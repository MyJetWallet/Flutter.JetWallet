enum ConditionType {
  kYCCondition,
  tradeCondition,
  referralCondition,
  depositCondition,
  withdrawalCondition,
  conditionsCondition,
  none,
}

extension ConditionTypeValue on ConditionType {
  int get value {
    if (this == ConditionType.kYCCondition) {
      return 0;
    } else if (this == ConditionType.tradeCondition) {
      return 1;
    } else if (this == ConditionType.referralCondition) {
      return 2;
    } else if (this == ConditionType.depositCondition) {
      return 3;
    } else if (this == ConditionType.withdrawalCondition) {
      return 4;
    } else if (this == ConditionType.conditionsCondition) {
      return 5;
    } else {
      return -1;
    }
  }
}

// int conditionTypeSwitch(ConditionType condition) {
//   switch (condition) {
//     case ConditionType.kYCCondition:
//       return 0;
//     case ConditionType.tradeCondition:
//       return 1;
//     case ConditionType.referralCondition:
//       return 2;
//     case ConditionType.depositCondition:
//       return 3;
//     case ConditionType.withdrawalCondition:
//       return 4;
//     case ConditionType.conditionsCondition:
//       return 5;
//     default:
//       return -1;
//   }
// }
