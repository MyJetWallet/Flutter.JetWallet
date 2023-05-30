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

  factory GlobalSendMethodsModel.fromJson(Map<String, dynamic> json) =>
      _$GlobalSendMethodsModelFromJson(json);
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

@freezed
class GlobalSendMethodsModelDescription
    with _$GlobalSendMethodsModelDescription {
  factory GlobalSendMethodsModelDescription({
    final int? type,
    final List<FieldInfo>? fields,
  }) = _GlobalSendMethodsModelDescription;

  factory GlobalSendMethodsModelDescription.fromJson(
          Map<String, dynamic> json) =>
      _$GlobalSendMethodsModelDescriptionFromJson(json);
}

@freezed
class FieldInfo with _$FieldInfo {
  factory FieldInfo({
    final String? fieldId,
    final String? fieldName,
    final int? weight,
  }) = _FieldInfo;

  factory FieldInfo.fromJson(Map<String, dynamic> json) =>
      _$FieldInfoFromJson(json);
}
