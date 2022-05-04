import 'package:freezed_annotation/freezed_annotation.dart';

enum RecurringBuysStatus {
  @JsonValue(0)
  active,
  @JsonValue(1)
  paused,
  @JsonValue(2)
  deleted,
  empty,
}

String recurringBuysStatusName(RecurringBuysStatus status) {
  switch (status) {
    case RecurringBuysStatus.active:
      return 'Active';
    case RecurringBuysStatus.paused:
      return 'Paused';
    case RecurringBuysStatus.deleted:
      return 'Deleted';
    default:
      return 'Empty';
  }
}
