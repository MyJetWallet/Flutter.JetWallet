import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:simple_networking/modules/signal_r/models/recurring_buys_model.dart';

String recurringBuysName(
  RecurringBuysStatus type,
) {
  switch (type) {
    case RecurringBuysStatus.active:
      return '${intl.account_recurringBuy} ';
    case RecurringBuysStatus.paused:
      return intl.recurringBuysName_paused;
    case RecurringBuysStatus.deleted:
      return intl.recurringBuysName_deleted;
    case RecurringBuysStatus.empty:
      return '${intl.recurringBuysName_empty} ';
  }
}
