import 'package:freezed_annotation/freezed_annotation.dart';

part 'post_device_binding_request_model.freezed.dart';
part 'post_device_binding_request_model.g.dart';

@freezed
class PostDeviceBindingRequestModel with _$PostDeviceBindingRequestModel {
  const factory PostDeviceBindingRequestModel({
    @JsonKey(name: 'language') required String locale,
    required int verificationType,
    required String requestId,
  }) = _PostDeviceBindingRequestModel;

  factory PostDeviceBindingRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$PostDeviceBindingRequestModelFromJson(json);
}
