import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_info_response_model.freezed.dart';
part 'session_info_response_model.g.dart';

@freezed
class SessionInfoResponseModel with _$SessionInfoResponseModel {
  const factory SessionInfoResponseModel({
    String? tokenLifetimeRemaining,
    required bool hasDisclaimers,
    required bool emailVerified,
    // If phone is not verified 2FA requests will fail
    required bool phoneVerified,
    required bool hasHighYieldDisclaimers,
    required bool isTechClient,
    // Shows whether user passed 2FA at the current session or not
    @JsonKey(name: 'twoFactorAuthentication') required bool twoFaPassed,
    @JsonKey(name: 'twoFactorAuthenticationEnabled') required bool twoFaEnabled,
    bool? toCheckSelfie,
  }) = _SessionInfoResponseModel;

  factory SessionInfoResponseModel.fromJson(Map<String, dynamic> json) => _$SessionInfoResponseModelFromJson(json);
}
