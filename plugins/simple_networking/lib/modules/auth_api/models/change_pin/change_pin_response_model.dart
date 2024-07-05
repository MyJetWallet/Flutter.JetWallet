import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_pin_response_model.freezed.dart';
part 'change_pin_response_model.g.dart';

@freezed
class ChangePinResponseModel with _$ChangePinResponseModel {
  const factory ChangePinResponseModel({
    required String result,
  }) = _ChangePinResponseModel;

  factory ChangePinResponseModel.fromJson(Map<String, dynamic> json) => _$ChangePinResponseModelFromJson(json);
}
