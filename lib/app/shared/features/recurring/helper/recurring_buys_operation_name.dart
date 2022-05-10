import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_analytics/simple_analytics.dart';

enum RecurringBuysType {
  @JsonValue(0)
  oneTimePurchase,
  @JsonValue(1)
  daily,
  @JsonValue(2)
  weekly,
  @JsonValue(3)
  biWeekly,
  @JsonValue(4)
  monthly,
}

String recurringBuysOperationName(RecurringBuysType type) {
  switch (type) {
    case RecurringBuysType.oneTimePurchase:
      return 'One-time purchase';
    case RecurringBuysType.daily:
      return 'Daily';
    case RecurringBuysType.weekly:
      return 'Weekly';
    case RecurringBuysType.biWeekly:
      return 'Bi-weekly';
    case RecurringBuysType.monthly:
      return 'Monthly';
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
