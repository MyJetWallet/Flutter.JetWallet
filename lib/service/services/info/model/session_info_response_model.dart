import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_info_response_model.freezed.dart';
part 'session_info_response_model.g.dart';

@freezed
class SessionInfoResponseModel with _$SessionInfoResponseModel {
  const factory SessionInfoResponseModel({
    required bool emailVerified,
    required bool phoneVerified,
    required bool twoFactorAuthentication,
    required bool twoFactorAuthenticationEnabled,
    String? tokenLifetimeRemaining,
  }) = _SessionInfoResponseModel;

  factory SessionInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SessionInfoResponseModelFromJson(json);
}
