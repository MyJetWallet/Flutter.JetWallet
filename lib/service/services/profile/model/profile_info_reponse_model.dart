import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_info_reponse_model.freezed.dart';
part 'profile_info_reponse_model.g.dart';

@freezed
class ProfileInfoResponseModel with _$ProfileInfoResponseModel {
  const factory ProfileInfoResponseModel({
    String? clientId,
    String? referralCode,
    String? referrerClientId,
    String? email,
    String? firstName,
    String? lastName,
    @JsonKey(name: 'sex') UserGender? gender,
    DateTime? dateOfBirth,
    String? countryOfResidence,
    String? countryOfCitizenship,
    String? city,
    String? postalCode,
    String? phone,
    String? address,
    bool? usCitizen,
    String? countryOfRegistration,
    String? ipOfRegistration,
    String? brandId,
    String? platformType,
    required Status2FA status2FA,
    required bool emailConfirmed,
    required bool phoneConfirmed,
    required bool kycPassed,
    required String createdAt,
  }) = _ProfileInfoResponseModel;

  factory ProfileInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileInfoResponseModelFromJson(json);
}

enum UserGender {
  @JsonValue(0)
  unknown,
  @JsonValue(1)
  male,
  @JsonValue(2)
  female,
}

enum Status2FA {
  @JsonValue(0)
  notSet,
  @JsonValue(1)
  disabled,
  @JsonValue(2)
  enabled,
}
