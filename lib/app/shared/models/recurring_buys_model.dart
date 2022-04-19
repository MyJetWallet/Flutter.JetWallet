import 'package:freezed_annotation/freezed_annotation.dart';

import '../features/recurring/helper/recurring_buys_status_name.dart';
import '../helpers/recurring_operation_name.dart';

part 'recurring_buys_model.freezed.dart';
part 'recurring_buys_model.g.dart';

@freezed
class RecurringBuysModel with _$RecurringBuysModel {
  const factory RecurringBuysModel({
    double? fromAmount,
    String? scheduledTime,
    int? scheduledDayOfWeek,
    int? scheduledDayOfMonth,
    String? creationTime,
    String? lastExecutionTime,
    @Default(RecurringBuysStatus.empty) RecurringBuysStatus status,
    @Default(0) int totalFromAmount,
    @Default(0) int totalToAmount,
    required RecurringBuyType scheduleType,
    required String fromAsset,
    required String toAsset,
  }) = _RecurringBuysModel;

  factory RecurringBuysModel.fromJson(Map<String, dynamic> json) =>
      _$RecurringBuysModelFromJson(json);
}
