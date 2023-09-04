import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_pay_config.freezed.dart';
part 'google_pay_config.g.dart';

@freezed
class GooglePayConfig with _$GooglePayConfig {
  factory GooglePayConfig({
    required String provider,
    required GooglePayConfigData data,
  }) = _GooglePayConfig;

  factory GooglePayConfig.fromJson(Map<String, dynamic> json) =>
      _$GooglePayConfigFromJson(json);
}

@freezed
class GooglePayConfigData with _$GooglePayConfigData {
  factory GooglePayConfigData({
    String? environment,
    required int apiVersion,
    required int apiVersionMinor,
    required List<GooglePayConfigAllowedPaymentMethod> allowedPaymentMethods,
    required GooglePayConfigMerchantInfo merchantInfo,
    required GooglePayConfigTransactionInfo transactionInfo,
  }) = _GooglePayConfigData;

  factory GooglePayConfigData.fromJson(Map<String, dynamic> json) =>
      _$GooglePayConfigDataFromJson(json);
}

@freezed
class GooglePayConfigAllowedPaymentMethod
    with _$GooglePayConfigAllowedPaymentMethod {
  factory GooglePayConfigAllowedPaymentMethod({
    required String type,
    required GooglePayConfigTokenizationSpec tokenizationSpecification,
    required GooglePayConfigParameters parameters,
  }) = _GooglePayConfigAllowedPaymentMethod;

  factory GooglePayConfigAllowedPaymentMethod.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$GooglePayConfigAllowedPaymentMethodFromJson(json);
}

@freezed
class GooglePayConfigParameters with _$GooglePayConfigParameters {
  factory GooglePayConfigParameters({
    required List<String> allowedAuthMethods,
    required List<String> allowedCardNetworks,
  }) = _GooglePayConfigParameters;

  factory GooglePayConfigParameters.fromJson(Map<String, dynamic> json) =>
      _$GooglePayConfigParametersFromJson(json);
}

@freezed
class GooglePayConfigTokenizationSpec with _$GooglePayConfigTokenizationSpec {
  factory GooglePayConfigTokenizationSpec({
    required String type,
    required GooglePayConfigTokenSpecP parameters,
  }) = _GooglePayConfigTokenizationSpec;

  factory GooglePayConfigTokenizationSpec.fromJson(Map<String, dynamic> json) =>
      _$GooglePayConfigTokenizationSpecFromJson(json);
}

@freezed
class GooglePayConfigTokenSpecP with _$GooglePayConfigTokenSpecP {
  factory GooglePayConfigTokenSpecP({
    required String gateway,
    required String gatewayMerchantId,
  }) = _GooglePayConfigTokenSpecP;

  factory GooglePayConfigTokenSpecP.fromJson(Map<String, dynamic> json) =>
      _$GooglePayConfigTokenSpecPFromJson(json);
}

@freezed
class GooglePayConfigMerchantInfo with _$GooglePayConfigMerchantInfo {
  factory GooglePayConfigMerchantInfo({
    required String merchantId,
    required String merchantName,
  }) = _GooglePayConfigMerchantInfo;

  factory GooglePayConfigMerchantInfo.fromJson(Map<String, dynamic> json) =>
      _$GooglePayConfigMerchantInfoFromJson(json);
}

@freezed
class GooglePayConfigTransactionInfo with _$GooglePayConfigTransactionInfo {
  factory GooglePayConfigTransactionInfo({
    required String countryCode,
    required String currencyCode,
  }) = _GooglePayConfigTransactionInfo;

  factory GooglePayConfigTransactionInfo.fromJson(Map<String, dynamic> json) =>
      _$GooglePayConfigTransactionInfoFromJson(json);
}
