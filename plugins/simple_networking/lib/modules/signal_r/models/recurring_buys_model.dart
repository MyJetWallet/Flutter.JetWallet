import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';

part 'recurring_buys_model.freezed.dart';
part 'recurring_buys_model.g.dart';

@freezed
class RecurringBuysModel with _$RecurringBuysModel {
  const factory RecurringBuysModel({
    double? fromAmount,
    String? scheduledTime,
    double? scheduledDayOfWeek,
    double? scheduledDayOfMonth,
    String? nextExecution,
    String? lastExecutionTime,
    String? id,
    @Default(RecurringBuysStatus.empty) RecurringBuysStatus status,
    @Default(0) double totalFromAmount,
    @Default(0) double totalToAmount,
    @Default(0) double avgPrice,
    @Default(0) double lastToAmount,
    required String creationTime,
    required RecurringBuysType scheduleType,
    required String fromAsset,
    required String toAsset,
  }) = _RecurringBuysModel;

  factory RecurringBuysModel.fromJson(Map<String, dynamic> json) => _$RecurringBuysModelFromJson(json);
}

enum RecurringBuysStatus {
  @JsonValue(0)
  active,
  @JsonValue(1)
  paused,
  @JsonValue(2)
  deleted,
  empty,
}
