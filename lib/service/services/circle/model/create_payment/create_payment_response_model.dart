import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_payment_response_model.freezed.dart';
part 'create_payment_response_model.g.dart';

@freezed
class CreatePaymentResponseModel with _$CreatePaymentResponseModel {
  const factory CreatePaymentResponseModel({
    required String name,
  }) = _CreatePaymentResponseModel;

  factory CreatePaymentResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePaymentResponseModelFromJson(json);
}
