import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_device_binding_verify_model.freezed.dart';
part 'post_device_binding_verify_model.g.dart';

@freezed
class PostDeviceBindingVerifyModel with _$PostDeviceBindingVerifyModel {
  const factory PostDeviceBindingVerifyModel({
    required String code,
  }) = _PostDeviceBindingVerifyModel;

  factory PostDeviceBindingVerifyModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$PostDeviceBindingVerifyModelFromJson(json);
}
