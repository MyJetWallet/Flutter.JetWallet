import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'create_payment_request_model.freezed.dart';
part 'create_payment_request_model.g.dart';

@freezed
class CreatePaymentRequestModel with _$CreatePaymentRequestModel {
  const factory CreatePaymentRequestModel({
    required String requestGuid,
    required String keyId,
    required String cardId,
    @DecimalSerialiser() required Decimal amount,
    @JsonKey(name: 'currency') required String currencySymbol,
    required String encryptedData,
  }) = _CreatePaymentRequestModel;

  factory CreatePaymentRequestModel.fromJson(Map<String, dynamic> json) => _$CreatePaymentRequestModelFromJson(json);
}
