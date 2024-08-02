import 'package:freezed_annotation/freezed_annotation.dart';

part 'remote_config_merchant_pay.freezed.dart';
part 'remote_config_merchant_pay.g.dart';

@freezed
class RemoteConfigMerchantPay with _$RemoteConfigMerchantPay {
  factory RemoteConfigMerchantPay({
    String? displayName,
    List<String>? merchantCapabilities,
    List<String>? supportedNetworks,
    String? countryCode,
  }) = _RemoteConfigMerchantPay;

  factory RemoteConfigMerchantPay.fromJson(Map<String, dynamic> json) => _$RemoteConfigMerchantPayFromJson(json);
}
