import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_payment_request_model.freezed.dart';
part 'create_payment_request_model.g.dart';

@freezed
class CreatePaymentRequestModel with _$CreatePaymentRequestModel {
  const factory CreatePaymentRequestModel({
    required String name,
  }) = _CreatePaymentRequestModel;

  factory CreatePaymentRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreatePaymentRequestModelFromJson(json);
}
