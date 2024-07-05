import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_pin_request_model.freezed.dart';
part 'reset_pin_request_model.g.dart';

@freezed
class ResetPinRequestModel with _$ResetPinRequestModel {
  const factory ResetPinRequestModel() = _ResetPinRequestModel;

  factory ResetPinRequestModel.fromJson(Map<String, dynamic> json) => _$ResetPinRequestModelFromJson(json);
}
