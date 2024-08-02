import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_report_request.freezed.dart';
part 'profile_report_request.g.dart';

@freezed
class ProfileReportRequest with _$ProfileReportRequest {
  factory ProfileReportRequest({
    required String messageId,
  }) = _ProfileReportRequest;

  factory ProfileReportRequest.fromJson(Map<String, dynamic> json) => _$ProfileReportRequestFromJson(json);
}
