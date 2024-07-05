import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_config_model.freezed.dart';
part 'app_config_model.g.dart';

@freezed
class AppConfigModel with _$AppConfigModel {
  const factory AppConfigModel({
    required int emailVerificationCodeLength,
    required int phoneVerificationCodeLength,
    required String userAgreementLink,
    required String privacyPolicyLink,
    required String referralPolicyLink,
    @Default('https://nft.simple.app/terms-and-conditions') String nftTermsLink,
    @Default('https://nft.simple.app/privacy-policy') String nftPolicyLink,
    @Default('Simple Europe UAB') String simpleCompanyName,
    @Default('Gyneju str. 14-65, Vilnius, Republic of Lithuania, 01109') String simpleCompanyAddress,
    required String refundPolicyLink,
    required String infoRewardsLink,
    required String infoEarnLink,
    required String amlKycPolicyLink,
    required int paymentDelayDays,
    required String privacyEarnLink,
    required int minAmountOfCharsInPassword,
    required int maxAmountOfCharsInPassword,
    required int quoteRetryInterval,
    required String defaultAssetIcon,
    required int emailResendCountdown,
    required int withdrawConfirmResendCountdown,
    required int localPinLength,
    required int maxPinAttempts,
    required int forgotPasswordLockHours,
    required int changePasswordLockHours,
    required int changePhoneLockHours,
  }) = _AppConfigModel;

  factory AppConfigModel.fromJson(Map<String, dynamic> json) => _$AppConfigModelFromJson(json);
}
