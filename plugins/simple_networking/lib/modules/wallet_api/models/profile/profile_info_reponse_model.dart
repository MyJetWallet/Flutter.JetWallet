import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_info_reponse_model.freezed.dart';
part 'profile_info_reponse_model.g.dart';

@freezed
class ProfileInfoResponseModel with _$ProfileInfoResponseModel {
  const factory ProfileInfoResponseModel({
    String? referralCode,
    String? referralLink,
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
    required Status2FA status2FA,
    required bool emailConfirmed,
    required bool phoneConfirmed,
    required bool kycPassed,
    required bool cardAvailable,
    required bool cardRequested,
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
