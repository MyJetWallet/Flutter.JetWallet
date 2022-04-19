import 'recurring_buys_status_name.dart';

String recurringBuysName(RecurringBuysStatus type) {
  switch (type) {
    case RecurringBuysStatus.active:
      return 'Recurring buy';
    case RecurringBuysStatus.paused:
      return 'Recurring buy\n[Paused]';
    case RecurringBuysStatus.deleted:
      return 'Recurring buy\n[Deleted]';
    case RecurringBuysStatus.empty:
      return 'Setup\nRecurring buy';
  }
}
