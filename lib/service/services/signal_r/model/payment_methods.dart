import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_methods.freezed.dart';
part 'payment_methods.g.dart';

@freezed
class AssetPaymentMethods with _$AssetPaymentMethods {
  const factory AssetPaymentMethods({
    required List<AssetPaymentInfo> assets,
  }) = _AssetPaymentMethods;

  factory AssetPaymentMethods.fromJson(Map<String, dynamic> json) =>
      _$AssetPaymentMethodsFromJson(json);
}

@freezed
class AssetPaymentInfo with _$AssetPaymentInfo {
  const factory AssetPaymentInfo({
    required String symbol,
    required List<PaymentMethod> buyMethods,
    required List<PaymentMethod> depositMethods,
    required List<PaymentMethod> withdrawalMethods,
  }) = _AssetPaymentInfo;

  factory AssetPaymentInfo.fromJson(Map<String, dynamic> json) =>
      _$AssetPaymentInfoFromJson(json);
}

@freezed
class PaymentMethod with _$PaymentMethod {
  const factory PaymentMethod({
    required String name,
    required double minAmount,
    required double maxAmount,
    required double availableAmount,
  }) = _PaymentMethod;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
}
