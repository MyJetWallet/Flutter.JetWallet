import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'get_crypto_sell_request_model.freezed.dart';

part 'get_crypto_sell_request_model.g.dart';

@freezed
abstract class GetCryptoSellRequestModel with _$GetCryptoSellRequestModel {
  const factory GetCryptoSellRequestModel({
    required String paymentAsset,
    required String buyAsset,
    @DecimalSerialiser() required Decimal buyAmount,
    required bool buyFixed,
    @DecimalSerialiser() required Decimal paymentAmount,
    @Default('IbanSell') String sellMethod,
    required String destinationAccountId,
    SelfWithdrawalDataModel? selfWithdrawalData,
    PersonWithdrawalDataModel? personWithdrawalData,
    BusinessWithdrawalDataModel? businessWithdrawalData,
  }) = _GetCryptoSellRequestModel;

  factory GetCryptoSellRequestModel.fromJson(Map<String, dynamic> json) => _$GetCryptoSellRequestModelFromJson(json);
}

@freezed
abstract class SelfWithdrawalDataModel with _$SelfWithdrawalDataModel {
  const factory SelfWithdrawalDataModel({
    required String toIban,
    required String bankCode,
  }) = _SelfWithdrawalDataModel;

  factory SelfWithdrawalDataModel.fromJson(Map<String, dynamic> json) => _$SelfWithdrawalDataModelFromJson(json);
}

@freezed
abstract class PersonWithdrawalDataModel with _$PersonWithdrawalDataModel {
  const factory PersonWithdrawalDataModel({
    required String contactId,
    required String toIban,
    required String beneficiaryName,
    required String beneficiaryAddress,
    required String beneficiaryCountry,
    required String bankCode,
    required String intermediaryBankCode,
    required String intermediaryBankAccount,
  }) = _PersonWithdrawalDataModel;

  factory PersonWithdrawalDataModel.fromJson(Map<String, dynamic> json) => _$PersonWithdrawalDataModelFromJson(json);
}

@freezed
abstract class BusinessWithdrawalDataModel with _$BusinessWithdrawalDataModel {
  const factory BusinessWithdrawalDataModel({
    required String toIban,
    required String beneficiaryName,
    required String beneficiaryAddress,
    required String beneficiaryCountry,
    required String bankCode,
    required String intermediaryBankCode,
    required String intermediaryBankAccount,
  }) = _BusinessWithdrawalDataModel;

  factory BusinessWithdrawalDataModel.fromJson(Map<String, dynamic> json) =>
      _$BusinessWithdrawalDataModelFromJson(json);
}
