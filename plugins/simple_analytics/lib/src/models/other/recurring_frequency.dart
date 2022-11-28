enum RecurringFrequency {
  oneTime,
  daily,
  weekly,
  biWeekly,
  monthly,
}

extension RecurringFrequencyExtension on RecurringFrequency {
  String get name {
    switch (this) {
      case RecurringFrequency.oneTime:
        return 'One time';
      case RecurringFrequency.daily:
        return 'Daily';
      case RecurringFrequency.weekly:
        return 'Weekly';
      case RecurringFrequency.biWeekly:
        return 'Bi-weekly';
      case RecurringFrequency.monthly:
        return 'Monthly';
    }
  }
}
