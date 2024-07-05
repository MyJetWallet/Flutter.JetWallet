import 'package:freezed_annotation/freezed_annotation.dart';

part 'check_pin_request_model.freezed.dart';
part 'check_pin_request_model.g.dart';

@freezed
class CheckPinRequestModel with _$CheckPinRequestModel {
  const factory CheckPinRequestModel({
    required String pin,
  }) = _CheckPinRequestModel;

  factory CheckPinRequestModel.fromJson(Map<String, dynamic> json) => _$CheckPinRequestModelFromJson(json);
}
