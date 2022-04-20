enum RecurringBuyType {
  daily,
  weekly,
  biWeekly,
  monthly,
}


String recurringBuyName(RecurringBuyType type) {
  switch (type) {
    case RecurringBuyType.daily:
      return 'Daily';
    case RecurringBuyType.weekly:
      return 'Weekly';
    case RecurringBuyType.biWeekly:
      return 'Bi-weekly';
    case RecurringBuyType.monthly:
      return 'Monthly';
  }
}
