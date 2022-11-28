import 'package:freezed_annotation/freezed_annotation.dart';

part 'start_email_login_request_model.freezed.dart';
part 'start_email_login_request_model.g.dart';

@freezed
class StartEmailLoginRequestModel with _$StartEmailLoginRequestModel {
  const factory StartEmailLoginRequestModel({
    required String email,
    required int application,
    required int platform,
    String? deviceUid,
    String? lang,
    String? appsflyerId,
    String? adid,
    String? idfv,
    String? idfa,
  }) = _StartEmailLoginRequestModel;
  factory StartEmailLoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$StartEmailLoginRequestModelFromJson(json);
}
