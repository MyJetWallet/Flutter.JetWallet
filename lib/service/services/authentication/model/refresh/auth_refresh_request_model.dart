import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_refresh_request_model.freezed.dart';
part 'auth_refresh_request_model.g.dart';

@freezed
class AuthRefreshRequestModel with _$AuthRefreshRequestModel {
  const factory AuthRefreshRequestModel({
    String? tokenDateTimeSignatureBase64,
    @JsonKey(name: 'requestDataTime') String? requestTime,
    required String refreshToken,
  }) = _AuthRefreshRequestModel;

  factory AuthRefreshRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AuthRefreshRequestModelFromJson(json);
}
