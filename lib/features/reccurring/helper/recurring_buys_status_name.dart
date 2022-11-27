import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_model.dart';

String recurringBuysStatusName(
  RecurringBuysStatus status,
) {
  switch (status) {
    case RecurringBuysStatus.active:
      return intl.recurringBuysStatus_active;
    case RecurringBuysStatus.paused:
      return intl.recurringBuysStatus_paused;
    case RecurringBuysStatus.deleted:
      return intl.recurringBuysStatus_deleted;
    default:
      return intl.recurringBuysStatus_empty;
  }
}
