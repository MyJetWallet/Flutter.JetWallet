import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../helpers/decimal_serialiser.dart';

part 'iban_info_response_model.freezed.dart';
part 'iban_info_response_model.g.dart';

@freezed
class IbanInfoResponseModel with _$IbanInfoResponseModel {
  const factory IbanInfoResponseModel({
    IbanInfoStatusDto? status,
    IbanModel? iban,
    RequirementsModel? requirements,
    IncomingFeeDetailModel? incomingFeeDetail,
  }) = _IbanInfoResponseModel;

  factory IbanInfoResponseModel.fromJson(Map<String, dynamic> json) =>
      _$IbanInfoResponseModelFromJson(json);
}

enum IbanInfoStatusDto {
  @JsonValue(0)
  notExist,
  @JsonValue(1)
  inProcess,
  @JsonValue(2)
  allow,
  @JsonValue(3)
  block,
}

@freezed
class IbanModel with _$IbanModel {
  const factory IbanModel({
    String? iban,
    String? bic,
    String? currency,
  }) = _IbanModel;

  factory IbanModel.fromJson(Map<String, dynamic> json) =>
      _$IbanModelFromJson(json);
}

@freezed
class RequirementsModel with _$RequirementsModel {
  const factory RequirementsModel({
    @Default(false) bool toSetupAddress,
    @Default(false) bool toSetupKyc,
  }) = _RequirementsModel;

  factory RequirementsModel.fromJson(Map<String, dynamic> json) =>
      _$RequirementsModelFromJson(json);
}

@freezed
class IncomingFeeDetailModel with _$IncomingFeeDetailModel {
  const factory IncomingFeeDetailModel({
    @DecimalSerialiser() Decimal? percentAmount,
    @DecimalSerialiser() Decimal? absoluteAmount,
  }) = _IncomingFeeDetailModel;

  factory IncomingFeeDetailModel.fromJson(Map<String, dynamic> json) =>
      _$IncomingFeeDetailModelFromJson(json);
}
