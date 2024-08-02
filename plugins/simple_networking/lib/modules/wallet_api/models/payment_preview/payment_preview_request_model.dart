import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_networking/helpers/decimal_serialiser.dart';

part 'payment_preview_request_model.freezed.dart';
part 'payment_preview_request_model.g.dart';

@freezed
class PaymentPreviewRequestModel with _$PaymentPreviewRequestModel {
  const factory PaymentPreviewRequestModel({
    required String cardId,
    @DecimalSerialiser() required Decimal amount,
    @JsonKey(name: 'currency') required String currencySymbol,
  }) = _PaymentPreviewRequestModel;

  factory PaymentPreviewRequestModel.fromJson(Map<String, dynamic> json) => _$PaymentPreviewRequestModelFromJson(json);
}
