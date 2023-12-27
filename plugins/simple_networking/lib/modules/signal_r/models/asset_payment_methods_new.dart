import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../helpers/decimal_serialiser.dart';
import 'asset_model.dart';
import 'asset_payment_methods.dart';

part 'asset_payment_methods_new.freezed.dart';
part 'asset_payment_methods_new.g.dart';

@freezed
class AssetPaymentMethodsNew with _$AssetPaymentMethodsNew {
  const factory AssetPaymentMethodsNew({
    List<BuyMethodDto>? buy,
    List<SendMethodDto>? send,
    List<ReceiveMethodDto>? receive,
    List<AssetPaymentProducts>? product,
    List<SellMethodDto>? sell,
    @Default(false) bool showCardsInProfile,
    @Default(false) bool showBanksInProfile,
  }) = _AssetPaymentMethodsNew;

  factory AssetPaymentMethodsNew.fromJson(Map<String, dynamic> json) => _$AssetPaymentMethodsNewFromJson(json);
}

@freezed
class BuyMethodDto with _$BuyMethodDto {
  const factory BuyMethodDto({
    @PaymentTypeSerialiser() @JsonKey(name: 'id') required PaymentMethodType id,
    final String? name,
    final PaymentMethodCategory? category,
    String? iconUrl,
    int? orderId,
    required bool termsAccepted,
    List<String>? allowedForSymbols,
    List<PaymentAsset>? paymentAssets,
  }) = _BuyMethodDto;

  factory BuyMethodDto.fromJson(Map<String, dynamic> json) => _$BuyMethodDtoFromJson(json);
}

@freezed
class SendMethodDto with _$SendMethodDto {
  const factory SendMethodDto({
    @WithdrawalMethodsSerialiser() @JsonKey(name: 'id') required WithdrawalMethods id,
    String? iconUrl,
    int? orderId,
    List<SymbolNetworkDetails>? symbolNetworkDetails,
  }) = _SendMethodDto;

  factory SendMethodDto.fromJson(Map<String, dynamic> json) => _$SendMethodDtoFromJson(json);
}

@freezed
class SendMethodDtoDetails with _$SendMethodDtoDetails {
  const factory SendMethodDtoDetails({
    final String? symbol,
    @DecimalNullSerialiser() final Decimal? minAmount,
    @DecimalNullSerialiser() final Decimal? maxAmount,
  }) = _SendMethodDtoDetails;

  factory SendMethodDtoDetails.fromJson(Map<String, dynamic> json) => _$SendMethodDtoDetailsFromJson(json);
}

@freezed
class ReceiveMethodDto with _$ReceiveMethodDto {
  const factory ReceiveMethodDto({
    @DepositMethodsSerialiser() @JsonKey(name: 'id') required DepositMethods id,
    String? iconUrl,
    int? orderId,
    List<String>? symbols,
  }) = _ReceiveMethodDto;

  factory ReceiveMethodDto.fromJson(Map<String, dynamic> json) => _$ReceiveMethodDtoFromJson(json);
}

@freezed
class PaymentAsset with _$PaymentAsset {
  const factory PaymentAsset({
    required String asset,
    @DecimalSerialiser() required Decimal minAmount,
    @DecimalSerialiser() required Decimal maxAmount,
    int? orderId,
    LimitDescription? limits,
    PresetDescription? presets,
  }) = _PaymentAsset;

  factory PaymentAsset.fromJson(Map<String, dynamic> json) => _$PaymentAssetFromJson(json);
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

  factory LimitDescription.fromJson(Map<String, dynamic> json) => _$LimitDescriptionFromJson(json);
}

@freezed
class PresetDescription with _$PresetDescription {
  const factory PresetDescription({
    @DecimalNullSerialiser() Decimal? amount1,
    @DecimalNullSerialiser() Decimal? amount2,
    @DecimalNullSerialiser() Decimal? amount3,
  }) = _PresetDescription;

  factory PresetDescription.fromJson(Map<String, dynamic> json) => _$PresetDescriptionFromJson(json);
}

@freezed
class SymbolNetworkDetails with _$SymbolNetworkDetails {
  const factory SymbolNetworkDetails({
    String? symbol,
    String? network,
    @DecimalNullSerialiser() final Decimal? minAmount,
    @DecimalNullSerialiser() final Decimal? maxAmount,
  }) = _SymbolNetworkDetails;

  factory SymbolNetworkDetails.fromJson(Map<String, dynamic> json) => _$SymbolNetworkDetailsFromJson(json);
}

@freezed
class AssetPaymentProducts with _$AssetPaymentProducts {
  const factory AssetPaymentProducts({
    AssetPaymentProductsEnum? id,
    String? iconUrl,
    int? orderId,
  }) = _AssetPaymentProducts;

  factory AssetPaymentProducts.fromJson(Map<String, dynamic> json) => _$AssetPaymentProductsFromJson(json);
}

@JsonEnum()
enum AssetPaymentProductsEnum {
  @JsonValue('RewardsOnboardingProgram')
  rewardsOnboardingProgram,
  @JsonValue('Unsupported')
  unsupported,
  @JsonValue('BankingIbanAccount')
  bankingIbanAccount,
  @JsonValue('BankingCardAccount')
  bankingCardAccount,
  @JsonValue('SimpleIbanAccount')
  simpleIbanAccount
}

@freezed
class SellMethodDto with _$SellMethodDto {
  const factory SellMethodDto({
    @SellMethodsIdSerialiser() @JsonKey(name: 'id') required SellMethodsId id,
    String? iconUrl,
    int? orderId,
    List<String>? symbols,
  }) = _SellMethodDto;

  factory SellMethodDto.fromJson(Map<String, dynamic> json) => _$SellMethodDtoFromJson(json);
}

enum SellMethodsId {
  ibanSell,
  unknown,
}

class SellMethodsIdSerialiser implements JsonConverter<SellMethodsId, dynamic> {
  const SellMethodsIdSerialiser();

  @override
  SellMethodsId fromJson(dynamic json) {
    final value = json.toString();

    if (value == 'IbanSell') {
      return SellMethodsId.ibanSell;
    } else {
      return SellMethodsId.unknown;
    }
  }

  @override
  dynamic toJson(SellMethodsId type) => type.name;
}
