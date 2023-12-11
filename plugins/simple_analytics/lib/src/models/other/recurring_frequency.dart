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

extension AnalyticsSendMethodsAnalyticsSendMethodsCodesExtension on AnalyticsSendMethods {
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

enum GlobalHistoryTab {
  all,
  pending,
}

extension GlobalHistoryTabName on GlobalHistoryTab {
  String get name {
    switch (this) {
      case GlobalHistoryTab.all:
        return 'All';
      case GlobalHistoryTab.pending:
        return 'Pending';
    }
  }
}

enum PaymenthMethodType {
  card('card'),
  cjAccount('CJ account'),
  unlimitAccount('Unlimit account');

  const PaymenthMethodType(this.name);
  final String name;
}

enum NowInputType {
  fiat('Fiat'),
  crypro('Crypto');

  const NowInputType(this.name);
  final String name;
}

enum FeeType {
  payment('Payment'),
  processing('Processing');

  const FeeType(this.name);
  final String name;
}
