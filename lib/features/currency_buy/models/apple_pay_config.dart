import 'package:freezed_annotation/freezed_annotation.dart';

part 'apple_pay_config.freezed.dart';
part 'apple_pay_config.g.dart';

@freezed
class ApplePayConfig with _$ApplePayConfig {
  factory ApplePayConfig({
    required String provider,
    required ApplePayConfigData data,
  }) = _ApplePayConfig;

  factory ApplePayConfig.fromJson(Map<String, dynamic> json) => _$ApplePayConfigFromJson(json);
}

@freezed
class ApplePayConfigData with _$ApplePayConfigData {
  factory ApplePayConfigData({
    required String merchantIdentifier,
    required String displayName,
    required List<String> merchantCapabilities,
    required List<String> supportedNetworks,
    required String countryCode,
    required String currencyCode,
    List<String>? requiredBillingContactFields,
    List<String>? requiredShippingContactFields,
  }) = _ApplePayConfigData;

  factory ApplePayConfigData.fromJson(Map<String, dynamic> json) => _$ApplePayConfigDataFromJson(json);
}
