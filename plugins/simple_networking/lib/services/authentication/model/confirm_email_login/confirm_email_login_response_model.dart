import 'package:freezed_annotation/freezed_annotation.dart';

part 'confirm_email_login_response_model.freezed.dart';
part 'confirm_email_login_response_model.g.dart';

@freezed
class ConfirmEmailLoginResponseModel with _$ConfirmEmailLoginResponseModel {
  const factory ConfirmEmailLoginResponseModel({
    required String token,
   required String refreshToken,
    String? rejectDetail,
  }) = _ConfirmEmailLoginResponseModel;
  factory ConfirmEmailLoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ConfirmEmailLoginResponseModelFromJson(json);
}
