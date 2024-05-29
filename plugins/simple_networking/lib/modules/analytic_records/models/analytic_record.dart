import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytic_record.freezed.dart';
part 'analytic_record.g.dart';

@freezed
class AnalyticRecordModel with _$AnalyticRecordModel {
  const factory AnalyticRecordModel({
    required String eventName,
    required Map<String, dynamic> eventBody,
    required int orderIndex,
  }) = _AnalyticRecordModel;

  factory AnalyticRecordModel.fromJson(Map<String, dynamic> json) =>
      _$AnalyticRecordModelFromJson(json);
}
