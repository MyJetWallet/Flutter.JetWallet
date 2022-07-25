import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_appconfig_model.freezed.dart';
part 'remote_config_appconfig_model.g.dart';

@freezed
class RemoteConfigAppconfigModel with _$RemoteConfigAppconfigModel {
  factory RemoteConfigAppconfigModel({
    required final String amlKycPolicyLink,
    required final String refundPolicyLink,
    required final int emailVerificationCodeLength,
    required final int phoneVerificationCodeLength,
    required final String userAgreementLink,
    required final String privacyPolicyLink,
    required final String referralPolicyLink,
    required final String cardLimitsLearnMoreLink,
    required final String privacyEarnLink,
    required final int paymentDelayDays,
    required final int minAmountOfCharsInPassword,
    required final String infoRewardsLink,
    required final String infoEarnLink,
    required final int maxAmountOfCharsInPassword,
    required final int quoteRetryInterval,
    required final String defaultAssetIcon,
    required final int emailResendCountdown,
    required final int withdrawConfirmResendCountdown,
    required final int localPinLength,
    required final int maxPinAttempts,
    required final int forgotPasswordLockHours,
    required final int changePasswordLockHours,
    required final int changePhoneLockHours,
  }) = _RemoteConfigAppconfigModel;

  factory RemoteConfigAppconfigModel.fromJson(Map<String, dynamic> json) =>
      _$RemoteConfigAppconfigModelFromJson(json);
}
