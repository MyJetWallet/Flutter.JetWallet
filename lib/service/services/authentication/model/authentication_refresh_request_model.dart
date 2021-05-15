import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_refresh_request_model.freezed.dart';

@freezed
class AuthenticationRefreshRequestModel
    with _$AuthenticationRefreshRequestModel {
  const factory AuthenticationRefreshRequestModel({
    required String refreshToken,
  }) = _AuthenticationRefreshRequestModel;
}
