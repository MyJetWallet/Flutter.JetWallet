import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../helpers/decimal_serialiser.dart';

part 'asset_payment_methods_new.freezed.dart';
part 'asset_payment_methods_new.g.dart';

@freezed
class AssetPaymentMethodsNew with _$AssetPaymentMethodsNew {
  const factory AssetPaymentMethodsNew({
    required List<BuyMethodDto> buy,
    required List<SendMethodDto> send,
    required List<ReceiveMethodDto> receive,
    @Default(false) bool showCardsInProfile,
    @Default(false) bool showBanksInProfile,
  }) = _AssetPaymentMethodsNew;

  factory AssetPaymentMethodsNew.fromJson(Map<String, dynamic> json) =>
      _$AssetPaymentMethodsNewFromJson(json);
}

@freezed
class BuyMethodDto with _$BuyMethodDto {
  const factory BuyMethodDto({
    required String id,
    required String iconUrl,
    required int orderId,
    required bool termsAccepted,
    required List<String> allowedForSymbols,
    required List<PaymentAsset> paymentAssets,
  }) = _BuyMethodDto;

  factory BuyMethodDto.fromJson(Map<String, dynamic> json) =>
      _$BuyMethodDtoFromJson(json);
}

@freezed
class SendMethodDto with _$SendMethodDto {
  const factory SendMethodDto({
    required String id,
    required String iconUrl,
    required int orderId,
    required List<String> allowedForSymbols,
  }) = _SendMethodDto;

  factory SendMethodDto.fromJson(Map<String, dynamic> json) =>
      _$SendMethodDtoFromJson(json);
}

@freezed
class ReceiveMethodDto with _$ReceiveMethodDto {
  const factory ReceiveMethodDto({
    required String id,
    required String iconUrl,
    required int orderId,
    required List<String> allowedForSymbols,
  }) = _ReceiveMethodDto;

  factory ReceiveMethodDto.fromJson(Map<String, dynamic> json) =>
      _$ReceiveMethodDtoFromJson(json);
}

@freezed
class PaymentAsset with _$PaymentAsset {
  const factory PaymentAsset({
    required String asset,
    @DecimalSerialiser() required Decimal minAmount,
    @DecimalSerialiser() required Decimal maxAmount,
    required int orderId,
    LimitDescription? limits,
  }) = _PaymentAsset;

  factory PaymentAsset.fromJson(Map<String, dynamic> json) =>
      _$PaymentAssetFromJson(json);
}

@freezed
class LimitDescription with _$LimitDescription {
  const factory LimitDescription({
    @DecimalSerialiser() required Decimal dayLimit,
    @DecimalSerialiser() required Decimal dayValue,
    @DecimalSerialiser() required Decimal weekLimit,
    @DecimalSerialiser() required Decimal weekValue,
    @DecimalSerialiser() required Decimal monthLimit,
    @DecimalSerialiser() required Decimal monthValue,
  }) = _LimitDescription;

  factory LimitDescription.fromJson(Map<String, dynamic> json) =>
      _$LimitDescriptionFromJson(json);
}
