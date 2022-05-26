import 'package:freezed_annotation/freezed_annotation.dart';

part 'simplex_payment_response_model.freezed.dart';
part 'simplex_payment_response_model.g.dart';

@freezed
class SimplexPaymentResponseModel with _$SimplexPaymentResponseModel {
  const factory SimplexPaymentResponseModel({
    required String paymentLink,
  }) = _SimplexPaymentResponseModel;

  factory SimplexPaymentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SimplexPaymentResponseModelFromJson(json);
}
