import 'package:freezed_annotation/freezed_annotation.dart';

part 'setup_pin_request_model.freezed.dart';
part 'setup_pin_request_model.g.dart';

@freezed
class SetupPinRequestModel with _$SetupPinRequestModel {
  const factory SetupPinRequestModel({
    required String pin,
  }) = _SetupPinRequestModel;

  factory SetupPinRequestModel.fromJson(Map<String, dynamic> json) => _$SetupPinRequestModelFromJson(json);
}
