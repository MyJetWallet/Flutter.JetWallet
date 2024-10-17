import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytic_record_response.freezed.dart';

part 'analytic_record_response.g.dart';

@freezed
class AnalyticRecordResponseModel with _$AnalyticRecordResponseModel {
  const factory AnalyticRecordResponseModel({
    required bool limitExceeded,
  }) = _AnalyticRecordResponseModel;

  factory AnalyticRecordResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AnalyticRecordResponseModelFromJson(json);
}
