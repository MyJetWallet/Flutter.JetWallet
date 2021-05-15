import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_refresh_response_model.freezed.dart';

@freezed
class AuthenticationRefreshResponseModel
    with _$AuthenticationRefreshResponseModel {
  const factory AuthenticationRefreshResponseModel({
    required String token,
    required String refreshToken,
  }) = _AuthenticationRefreshResponseModel;
}
