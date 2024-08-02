import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_pin_request_model.freezed.dart';
part 'change_pin_request_model.g.dart';

@freezed
class ChangePinRequestModel with _$ChangePinRequestModel {
  const factory ChangePinRequestModel({
    required String oldPin,
    required String newPin,
  }) = _ChangePinRequestModel;

  factory ChangePinRequestModel.fromJson(Map<String, dynamic> json) => _$ChangePinRequestModelFromJson(json);
}
