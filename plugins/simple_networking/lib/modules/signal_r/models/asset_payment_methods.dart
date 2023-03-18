import 'package:freezed_annotation/freezed_annotation.dart';

part 'asset_payment_methods.freezed.dart';
part 'asset_payment_methods.g.dart';

@freezed
class AssetPaymentMethods with _$AssetPaymentMethods {
  const factory AssetPaymentMethods({
    required List<AssetPaymentInfo> assets,
    @Default(false) bool showCardsInProfile,
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
  unlimintCard,
  unsupported,
  unlimintAlternative,
  bankCard,
  applePay,
  googlePay
}

extension _PaymentMethodTypeExtension on PaymentMethodType {
  String get name {
    switch (this) {
      case PaymentMethodType.simplex:
        return 'Simplex';
      case PaymentMethodType.circleCard:
        return 'CircleCard';
      case PaymentMethodType.unlimintCard:
        return 'UnlimintCard';
      case PaymentMethodType.unlimintAlternative:
        return 'UnlimintAlternative';
      case PaymentMethodType.bankCard:
        return 'BankCard';
      case PaymentMethodType.applePay:
        return 'UnlimintApplePay';
      case PaymentMethodType.googlePay:
        return 'UnlimintGooglePay';
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
    } else if (value == 'CircleCard') {
      return PaymentMethodType.circleCard;
    } else if (value == 'UnlimintCard') {
      return PaymentMethodType.unlimintCard;
    } else if (value == 'Unlimint') {
      return PaymentMethodType.unlimintCard;
    } else if (value == 'UnlimintAlternative') {
      return PaymentMethodType.unlimintAlternative;
    } else if (value == 'BankCard') {
      return PaymentMethodType.bankCard;
    } else if (value == 'UnlimintApplePay') {
      return PaymentMethodType.applePay;
    } else if (value == 'UnlimintGooglePay') {
      return PaymentMethodType.googlePay;
    } else {
      return PaymentMethodType.unsupported;
    }
  }

  @override
  dynamic toJson(PaymentMethodType type) => type.name;
}
