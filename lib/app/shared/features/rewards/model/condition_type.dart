enum ConditionType {
  kYCCondition,
  tradeCondition,
  referralCondition,
  depositCondition,
  withdrawalCondition,
  conditionsCondition,
  none,
}

int conditionTypeSwitch(ConditionType condition) {
  switch (condition) {
    case ConditionType.kYCCondition:
      return 0;
    case ConditionType.tradeCondition:
      return 1;
    case ConditionType.referralCondition:
      return 2;
    case ConditionType.depositCondition:
      return 3;
    case ConditionType.withdrawalCondition:
      return 4;
    case ConditionType.conditionsCondition:
      return 5;
    default:
      return -1;
  }
}
