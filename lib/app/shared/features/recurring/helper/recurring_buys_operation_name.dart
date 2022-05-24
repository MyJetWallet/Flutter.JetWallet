import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';

import '../../../../../shared/providers/service_providers.dart';

enum RecurringBuysType {
  @JsonValue(0)
  oneTimePurchase,
  @JsonValue(1)
  daily,
  @JsonValue(2)
  weekly,
  @JsonValue(3)
  biWeekly,
  @JsonValue(4)
  monthly,
}

String recurringBuysOperationName(
  RecurringBuysType type,
  BuildContext context,
) {
  final intl = context.read(intlPod);

  switch (type) {
    case RecurringBuysType.oneTimePurchase:
      return intl.recurringBuysType_oneTimePurchase;
    case RecurringBuysType.daily:
      return intl.recurringBuysType_daily;
    case RecurringBuysType.weekly:
      return intl.recurringBuysType_weekly;
    case RecurringBuysType.biWeekly:
      return intl.recurringBuysType_biWeekly;
    case RecurringBuysType.monthly:
      return intl.recurringBuysType_monthly;
  }
}

String recurringBuysOperationByString(
    String type,
    BuildContext context,
    ) {
  final intl = context.read(intlPod);

  switch (type) {
    case 'One time purchase':
      return intl.recurringBuysType_oneTimePurchase;
    case 'Daily':
      return intl.recurringBuysType_daily;
    case 'Weekly':
      return intl.recurringBuysType_weekly;
    case 'Biweekly':
      return intl.recurringBuysType_biWeekly;
    case 'Monthly':
      return intl.recurringBuysType_monthly;
    default:
      return '';
  }
}

extension RecurringBuyTypeExtension on RecurringBuysType {
  RecurringFrequency get toFrequency {
    switch (this) {
      case RecurringBuysType.oneTimePurchase:
        return RecurringFrequency.oneTime;
      case RecurringBuysType.daily:
        return RecurringFrequency.daily;
      case RecurringBuysType.weekly:
        return RecurringFrequency.weekly;
      case RecurringBuysType.biWeekly:
        return RecurringFrequency.biWeekly;
      case RecurringBuysType.monthly:
        return RecurringFrequency.monthly;
    }
  }
}
