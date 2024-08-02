import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'global_send_methods_model.freezed.dart';
part 'global_send_methods_model.g.dart';

@freezed
class GlobalSendMethodsModel with _$GlobalSendMethodsModel {
  factory GlobalSendMethodsModel({
    final List<GlobalSendMethodsModelMethods>? methods,
    final List<GlobalSendMethodsModelDescription>? descriptions,
  }) = _GlobalSendMethodsModel;

  factory GlobalSendMethodsModel.fromJson(Map<String, dynamic> json) => _$GlobalSendMethodsModelFromJson(json);
}

@freezed
class GlobalSendMethodsModelMethods with _$GlobalSendMethodsModelMethods {
  factory GlobalSendMethodsModelMethods({
    final String? methodId,
    final String? receiveAsset,
    final int? weight,
    final String? name,
    final String? description,
    @DecimalNullSerialiser() final Decimal? minAmount,
    @DecimalNullSerialiser() final Decimal? maxAmount,
    final int? type,
    final List<String>? countryCodes,
  }) = _GlobalSendMethodsModelMethods;

  factory GlobalSendMethodsModelMethods.fromJson(Map<String, dynamic> json) =>
      _$GlobalSendMethodsModelMethodsFromJson(json);
}

@Freezed(makeCollectionsUnmodifiable: false)
class GlobalSendMethodsModelDescription with _$GlobalSendMethodsModelDescription {
  factory GlobalSendMethodsModelDescription({
    final int? type,
    final List<FieldInfo>? fields,
  }) = _GlobalSendMethodsModelDescription;

  factory GlobalSendMethodsModelDescription.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$GlobalSendMethodsModelDescriptionFromJson(json);
}

@freezed
class FieldInfo with _$FieldInfo {
  factory FieldInfo({
    @FieldInfoIdSerialiser() final FieldInfoId? fieldId,
    final String? fieldName,
    final int? weight,
  }) = _FieldInfo;

  factory FieldInfo.fromJson(Map<String, dynamic> json) => _$FieldInfoFromJson(json);
}

enum FieldInfoId {
  cardNumber,
  iban,
  phoneNumber,
  recipientName,
  panNumber,
  upiAddress,
  accountNumber,
  beneficiaryName,
  bankName,
  ifscCode,
  bankAccount,
  wise,
  unknown
}

extension _DepositMethodsExtension on FieldInfoId {
  String get name {
    switch (this) {
      case FieldInfoId.cardNumber:
        return 'CardNumber';
      case FieldInfoId.iban:
        return 'Iban';
      case FieldInfoId.phoneNumber:
        return 'PhoneNumber';
      case FieldInfoId.recipientName:
        return 'RecipientName';
      case FieldInfoId.panNumber:
        return 'PanNumber';
      case FieldInfoId.upiAddress:
        return 'UpiAddress';
      case FieldInfoId.accountNumber:
        return 'AccountNumber';
      case FieldInfoId.beneficiaryName:
        return 'BeneficiaryName';
      case FieldInfoId.bankName:
        return 'BankName';
      case FieldInfoId.ifscCode:
        return 'IfscCode';
      case FieldInfoId.bankAccount:
        return 'BankAccount';
      case FieldInfoId.wise:
        return 'WiseCredentials';
      case FieldInfoId.unknown:
        return 'Unknown';
    }
  }
}

class FieldInfoIdSerialiser implements JsonConverter<FieldInfoId, dynamic> {
  const FieldInfoIdSerialiser();

  @override
  FieldInfoId fromJson(dynamic json) {
    final value = json.toString();

    switch (value) {
      case 'CardNumber':
        return FieldInfoId.cardNumber;
      case 'Iban':
        return FieldInfoId.iban;
      case 'PhoneNumber':
        return FieldInfoId.phoneNumber;
      case 'RecipientName':
        return FieldInfoId.recipientName;
      case 'PanNumber':
        return FieldInfoId.panNumber;
      case 'UpiAddress':
        return FieldInfoId.upiAddress;
      case 'AccountNumber':
        return FieldInfoId.accountNumber;
      case 'BeneficiaryName':
        return FieldInfoId.beneficiaryName;
      case 'BankAccount':
        return FieldInfoId.bankAccount;
      case 'IfscCode':
        return FieldInfoId.ifscCode;
      case 'BankName':
        return FieldInfoId.bankName;
      case 'WiseCredentials':
        return FieldInfoId.wise;
      default:
        return FieldInfoId.unknown;
    }
  }

  @override
  dynamic toJson(FieldInfoId type) => type.name;
}
