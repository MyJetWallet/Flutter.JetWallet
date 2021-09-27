import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_info_response_model.freezed.dart';
part 'session_info_response_model.g.dart';

@freezed
class SessionInfoResponseModel with _$SessionInfoResponseModel {
  const factory SessionInfoResponseModel({
    required bool emailVerified,

    /// If phone is not verified 2FA requests will fail
    required bool phoneVerified,

    /// Shows wether user required to complete 2FA or not
    required bool twoFactorAuthentication,
    String? tokenLifetimeRemaining,
  }) = _SessionInfoResponseModel;

  factory SessionInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SessionInfoResponseModelFromJson(json);
}
