import 'package:freezed_annotation/freezed_annotation.dart';

part 'start_email_login_response_model.freezed.dart';
part 'start_email_login_response_model.g.dart';

@freezed
class StartEmailLoginResponseModel with _$StartEmailLoginResponseModel {
  const factory StartEmailLoginResponseModel({
    required String verificationToken,
    String? rejectDetail,
  }) = _StartEmailLoginResponseModel;
  factory StartEmailLoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$StartEmailLoginResponseModelFromJson(json);
}
