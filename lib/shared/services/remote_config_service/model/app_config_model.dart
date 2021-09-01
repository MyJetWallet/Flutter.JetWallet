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
    required int minAmountOfCharsInPassword,
    required int maxAmountOfCharsInPassword,
    required int quoteRetryInterval,
    required String defaultAssetIcon,
  }) = _AppConfigModel;

  factory AppConfigModel.fromJson(Map<String, dynamic> json) =>
      _$AppConfigModelFromJson(json);
}
