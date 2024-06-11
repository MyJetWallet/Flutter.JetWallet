import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_appconfig_model.freezed.dart';
part 'remote_config_appconfig_model.g.dart';

@freezed
class RemoteConfigAppconfigModel with _$RemoteConfigAppconfigModel {
  factory RemoteConfigAppconfigModel({
    required String amlKycPolicyLink,
    required String refundPolicyLink,
    required int emailVerificationCodeLength,
    required int phoneVerificationCodeLength,
    required String userAgreementLink,
    required String privacyPolicyLink,
    required String referralPolicyLink,
    @Default('https://nft.simple.app/terms-and-conditions') String nftTermsLink,
    @Default('https://nft.simple.app/privacy-policy') String nftPolicyLink,
    @Default('Simple Europe UAB') String simpleCompanyName,
    @Default('Gyneju str. 14-65, Vilnius, Republic of Lithuania, 01109') String simpleCompanyAddress,
    required String cardLimitsLearnMoreLink,
    required String privacyEarnLink,
    required int paymentDelayDays,
    required int minAmountOfCharsInPassword,
    required String infoRewardsLink,
    required String infoEarnLink,
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
    @Default('https://simple.app/terms-and-conditions-p2p/') String p2pTerms,
    @Default(true) @JsonValue('rate_up') bool rateUp,
    @Default(false) bool displayCardPreorderScreen,
    @Default('') String prepaidCardPartnerLink,
    @Default('') String prepaidCardTermsAndConditionsLink,
    @Default(true) bool useAmplitude,
    @Default('https://simple.app/disclaimer/?tpl=blank') String simpleCoinDisclaimerLink,
    @Default('https://t.me/Simple_Tap_Bot') String simpleTapLink,
    @Default(true) bool usePhoneForSendGift,
  }) = _RemoteConfigAppconfigModel;

  factory RemoteConfigAppconfigModel.fromJson(Map<String, dynamic> json) => _$RemoteConfigAppconfigModelFromJson(json);
}
