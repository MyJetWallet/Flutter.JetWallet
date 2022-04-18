import 'package:freezed_annotation/freezed_annotation.dart';

enum RecurringBuyType {
  @JsonValue(1)
  daily,
  @JsonValue(2)
  weekly,
  @JsonValue(3)
  biWeekly,
  @JsonValue(4)
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
