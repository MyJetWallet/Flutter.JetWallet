import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/providers/service_providers.dart';
import 'recurring_buys_status_name.dart';

String recurringBuysName(
  RecurringBuysStatus type,
  Reader read,
) {
  final intl = read(intlPod);

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
