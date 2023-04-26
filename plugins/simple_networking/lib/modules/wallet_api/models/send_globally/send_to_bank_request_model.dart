import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'send_to_bank_request_model.freezed.dart';
part 'send_to_bank_request_model.g.dart';

@freezed
class SendToBankRequestModel with _$SendToBankRequestModel {
  factory SendToBankRequestModel({
    final String? requestId,
    final String? countryCode,
    final String? cardNumber,
    final String? asset,
    @DecimalSerialiser() Decimal? amount,
  }) = _SendToBankRequestModel;

  factory SendToBankRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SendToBankRequestModelFromJson(json);
}
