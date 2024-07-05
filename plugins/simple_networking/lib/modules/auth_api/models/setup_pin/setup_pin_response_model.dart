import 'package:freezed_annotation/freezed_annotation.dart';

part 'setup_pin_response_model.freezed.dart';
part 'setup_pin_response_model.g.dart';

@freezed
class SetupPinResponseModel with _$SetupPinResponseModel {
  const factory SetupPinResponseModel({
    required String result,
  }) = _SetupPinResponseModel;

  factory SetupPinResponseModel.fromJson(Map<String, dynamic> json) => _$SetupPinResponseModelFromJson(json);
}
