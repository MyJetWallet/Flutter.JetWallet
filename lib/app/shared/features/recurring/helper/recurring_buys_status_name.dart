import 'package:simple_networking/services/signal_r/model/recurring_buys_model.dart';

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
