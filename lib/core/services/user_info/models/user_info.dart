import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_info.freezed.dart';

@freezed
class UserInfoState with _$UserInfoState {
  const factory UserInfoState({
    String? pin,
    @Default(false) bool chatClosedOnThisSession,
    @Default(false) bool hasDisclaimers,
    @Default(false) bool hasNftDisclaimers,

    /// If after reister/login user disabled a pin.
    /// If pin is disabled manually we don't ask
    /// to set pin again (in authorized state)
    /// After logout this will be reseted
    @Default(false) bool pinDisabled,
    @Default(false) bool twoFaEnabled,
    @Default(false) bool phoneVerified,
    @Default(false) bool emailConfirmed,
    @Default(false) bool phoneConfirmed,
    @Default(false) bool kycPassed,
    @Default(false) bool hasHighYieldDisclaimers,
    @Default(false) bool isJustLogged,
    @Default(false) bool isJustRegistered,
    @Default(false) bool biometricDisabled,
    @Default(false) bool isTechClient,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String referralLink,
    @Default('') String referralCode,
    @Default('') String countryOfRegistration,
    @Default('') String countryOfResidence,
    @Default('') String countryOfCitizenship,
    @Default('') String firstName,
    @Default('') String lastName,
  }) = _UserInfoState;

  const UserInfoState._();

  bool get pinEnabled => pin != null;

  bool get isPhoneNumberSet => phone.isNotEmpty;

  bool get isShowBanner => !twoFaEnabled || !phoneVerified || !kycPassed;
}
