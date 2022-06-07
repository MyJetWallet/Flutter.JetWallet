import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/recurring_buys_model.dart';

import '../../../../../shared/providers/service_providers.dart';

String recurringBuysStatusName(
  RecurringBuysStatus status,
  BuildContext context,
) {
  final intl = context.read(intlPod);

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
