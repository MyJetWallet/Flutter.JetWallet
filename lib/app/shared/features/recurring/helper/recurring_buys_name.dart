import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/recurring_buys_model.dart';

import '../../../../../shared/providers/service_providers.dart';

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
