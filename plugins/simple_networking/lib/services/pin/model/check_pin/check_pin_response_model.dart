import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_pin_response_model.freezed.dart';
part 'check_pin_response_model.g.dart';

@freezed
class CheckPinResponseModel with _$CheckPinResponseModel {
  const factory CheckPinResponseModel({
    required String result,
  }) = _CheckPinResponseModel;

  factory CheckPinResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CheckPinResponseModelFromJson(json);
}
