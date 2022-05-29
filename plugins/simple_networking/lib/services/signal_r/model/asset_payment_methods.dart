import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_payment_methods.freezed.dart';
part 'asset_payment_methods.g.dart';

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
    @PaymentTypeSerialiser()
    @JsonKey(name: 'name')
        required PaymentMethodType type,
    required double minAmount,
    required double maxAmount,
    required double availableAmount,
  }) = _PaymentMethod;

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
}

enum PaymentMethodType {
  simplex,
  circleCard,
  unsupported,
}

extension PaymentMethodTypeExtension on PaymentMethodType {
  String get name {
    switch (this) {
      case PaymentMethodType.simplex:
        return 'Simplex';
      case PaymentMethodType.circleCard:
        return 'CircleCard';
      default:
        return 'Unsupported';
    }
  }
}

class PaymentTypeSerialiser
    implements JsonConverter<PaymentMethodType, dynamic> {
  const PaymentTypeSerialiser();

  @override
  PaymentMethodType fromJson(dynamic json) {
    final value = json.toString();

    if (value == 'Simplex') {
      return PaymentMethodType.simplex;
    } else {
      return PaymentMethodType.unsupported;
    }
  }

  @override
  dynamic toJson(PaymentMethodType type) => type.name;
}
