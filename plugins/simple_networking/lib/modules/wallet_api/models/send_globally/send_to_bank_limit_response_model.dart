import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'send_to_bank_limit_response_model.freezed.dart';

part 'send_to_bank_limit_response_model.g.dart';

@freezed
class SendToBankLimitResponseModel with _$SendToBankLimitResponseModel {
  factory SendToBankLimitResponseModel({
    @DecimalSerialiser() final Decimal? minAmount,
    @DecimalSerialiser() final Decimal? maxAmount,
  }) = _SendToBankLimitResponseModel;

  factory SendToBankLimitResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SendToBankLimitResponseModelFromJson(json);
}
