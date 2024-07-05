import 'package:freezed_annotation/freezed_annotation.dart';

part 'payment_info_request_model.freezed.dart';
part 'payment_info_request_model.g.dart';

@freezed
class PaymentInfoRequestModel with _$PaymentInfoRequestModel {
  const factory PaymentInfoRequestModel({
    required int depositId,
  }) = _PaymentInfoRequestModel;

  factory PaymentInfoRequestModel.fromJson(Map<String, dynamic> json) => _$PaymentInfoRequestModelFromJson(json);
}
