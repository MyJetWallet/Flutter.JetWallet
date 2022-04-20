import 'package:freezed_annotation/freezed_annotation.dart';

enum RecurringBuysType {
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
