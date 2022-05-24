import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../shared/providers/service_providers.dart';

enum RecurringBuysStatus {
  @JsonValue(0)
  active,
  @JsonValue(1)
  paused,
  @JsonValue(2)
  deleted,
  empty,
}

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
