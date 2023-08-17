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

enum AnalyticsSendMethods {
  cryptoWallet,
  globally,
  bankAccount,
  gift,
}

extension AnalyticsSendMethodsAnalyticsSendMethodsCodesExtension
    on AnalyticsSendMethods {
  int get code {
    switch (this) {
      case AnalyticsSendMethods.cryptoWallet:
        return 0;
      case AnalyticsSendMethods.globally:
        return 1;
      case AnalyticsSendMethods.bankAccount:
        return 2;
      case AnalyticsSendMethods.gift:
        return 3;
    }
  }
}
