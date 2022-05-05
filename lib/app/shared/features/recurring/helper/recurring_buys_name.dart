import 'package:simple_networking/services/signal_r/model/recurring_buys_model.dart';

String recurringBuysName(RecurringBuysStatus type) {
  switch (type) {
    case RecurringBuysStatus.active:
      return 'Recurring buy ';
    case RecurringBuysStatus.paused:
      return 'Recurring buy Paused';
    case RecurringBuysStatus.deleted:
      return 'Recurring buy Deleted';
    case RecurringBuysStatus.empty:
      return 'Setup Recurring buy ';
  }
}
