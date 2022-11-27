import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'transfer_by_phone_request_model.freezed.dart';
part 'transfer_by_phone_request_model.g.dart';

@freezed
class TransferByPhoneRequestModel with _$TransferByPhoneRequestModel {
  const factory TransferByPhoneRequestModel({
    required String requestId,
    required String assetSymbol,
    @DecimalSerialiser() required Decimal amount,
    @JsonKey(name: 'lang') required String locale,
    required String toPhoneCode,
    required String toPhoneBody,
    required String toPhoneIso,
  }) = _TransferByPhoneRequestModel;

  factory TransferByPhoneRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TransferByPhoneRequestModelFromJson(json);
}
