import 'package:freezed_annotation/freezed_annotation.dart';

part 'apple_pay_data_model.freezed.dart';
part 'apple_pay_data_model.g.dart';

@freezed
class ApplePayDataModel with _$ApplePayDataModel {
  factory ApplePayDataModel({
    required ApplePayDataModelToken token,
  }) = _ApplePayDataModel;

  factory ApplePayDataModel.fromJson(Map<String, dynamic> json) => _$ApplePayDataModelFromJson(json);
}

@freezed
class ApplePayDataModelPaymentMethod with _$ApplePayDataModelPaymentMethod {
  factory ApplePayDataModelPaymentMethod({
    required String displayName,
    required String network,
    required String type,
  }) = _ApplePayDataModelPaymentMethod;

  factory ApplePayDataModelPaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$ApplePayDataModelPaymentMethodFromJson(json);
}

@freezed
class ApplePayDataModelToken with _$ApplePayDataModelToken {
  factory ApplePayDataModelToken({
    required String transactionIdentifier,
    required ApplePayDataModelPaymentMethod paymentMethod,
    required ApplePayDataModelTokenPaymentData paymentData,
  }) = _ApplePayDataModelToken;

  factory ApplePayDataModelToken.fromJson(Map<String, dynamic> json) => _$ApplePayDataModelTokenFromJson(json);
}

@freezed
class ApplePayDataModelTokenData with _$ApplePayDataModelTokenData {
  factory ApplePayDataModelTokenData({
    required String ephemeralPublicKey,
    required String publicKeyHash,
    required String transactionId,
  }) = _ApplePayDataModelTokenData;

  factory ApplePayDataModelTokenData.fromJson(Map<String, dynamic> json) => _$ApplePayDataModelTokenDataFromJson(json);
}

@freezed
class ApplePayDataModelTokenPaymentData with _$ApplePayDataModelTokenPaymentData {
  factory ApplePayDataModelTokenPaymentData({
    required String version,
    required String data,
    required String signature,
    required ApplePayDataModelTokenData header,
  }) = _ApplePayDataModelTokenPaymentData;

  factory ApplePayDataModelTokenPaymentData.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$ApplePayDataModelTokenPaymentDataFromJson(json);
}
