import 'package:freezed_annotation/freezed_annotation.dart';

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
    required String fromAsset,
    required String toAsset,
    required int status,
    required int scheduleType,
  }) = _RecurringBuysModel;

  factory RecurringBuysModel.fromJson(Map<String, dynamic> json) =>
      _$RecurringBuysModelFromJson(json);
}
