import 'package:freezed_annotation/freezed_annotation.dart';

part 'kyc_plan_responce_model.freezed.dart';
part 'kyc_plan_responce_model.g.dart';

@freezed
class KycPlanResponceModel with _$KycPlanResponceModel {
  const factory KycPlanResponceModel({
    @Default(KycProvider.sumsub) KycProvider provider,
    @Default('') String countryCode,
    @Default(KycAction.allow) KycAction action,
    @Default('') String url,
  }) = _KycPlanResponceModel;

  factory KycPlanResponceModel.fromJson(Map<String, dynamic> json) => _$KycPlanResponceModelFromJson(json);
}

enum KycProvider {
  @JsonValue(0)
  kycAid,
  @JsonValue(1)
  sumsub,
}

enum KycAction {
  @JsonValue(0)
  chooseCountry,
  @JsonValue(1)
  webView,
  @JsonValue(2)
  inProcess,
  @JsonValue(3)
  block,
  @JsonValue(4)
  allow,
}
