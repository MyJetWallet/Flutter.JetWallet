import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';

String recurringBuysOperationName(
  RecurringBuysType type,
) {
  switch (type) {
    case RecurringBuysType.oneTimePurchase:
      return intl.recurringBuysType_oneTimePurchase;
    case RecurringBuysType.daily:
      return intl.recurringBuysType_daily;
    case RecurringBuysType.weekly:
      return intl.recurringBuysType_weekly;
    case RecurringBuysType.biWeekly:
      return intl.recurringBuysType_biWeekly;
    case RecurringBuysType.monthly:
      return intl.recurringBuysType_monthly;
  }
}

String recurringBuysOperationByString(
  String type,
) {
  switch (type) {
    case 'One time purchase':
      return intl.recurringBuysType_oneTimePurchase;
    case 'Daily':
      return intl.recurringBuysType_daily;
    case 'Weekly':
      return intl.recurringBuysType_weekly;
    case 'Biweekly':
      return intl.recurringBuysType_biWeekly;
    case 'Monthly':
      return intl.recurringBuysType_monthly;
    default:
      return '';
  }
}

extension RecurringBuyTypeExtension on RecurringBuysType {
  RecurringFrequency get toFrequency {
    switch (this) {
      case RecurringBuysType.oneTimePurchase:
        return RecurringFrequency.oneTime;
      case RecurringBuysType.daily:
        return RecurringFrequency.daily;
      case RecurringBuysType.weekly:
        return RecurringFrequency.weekly;
      case RecurringBuysType.biWeekly:
        return RecurringFrequency.biWeekly;
      case RecurringBuysType.monthly:
        return RecurringFrequency.monthly;
    }
  }
}
