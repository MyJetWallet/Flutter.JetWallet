import 'package:decimal/decimal.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'simplex_payment_request_model.freezed.dart';
part 'simplex_payment_request_model.g.dart';

@freezed
class SimplexPaymentRequestModel with _$SimplexPaymentRequestModel {
  const factory SimplexPaymentRequestModel({
    required Decimal fromAmount,
    required String fromCurrency,
    required String toAsset,
  }) = _SimplexPaymentRequestModel;

  factory SimplexPaymentRequestModel.fromJson(Map<String, dynamic> json) => _$SimplexPaymentRequestModelFromJson(json);
}
