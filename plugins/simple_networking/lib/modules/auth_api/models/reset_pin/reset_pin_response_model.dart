import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_pin_response_model.freezed.dart';
part 'reset_pin_response_model.g.dart';

@freezed
class ResetPinResponseModel with _$ResetPinResponseModel {
  const factory ResetPinResponseModel({
    required String result,
  }) = _ResetPinResponseModel;

  factory ResetPinResponseModel.fromJson(Map<String, dynamic> json) => _$ResetPinResponseModelFromJson(json);
}
