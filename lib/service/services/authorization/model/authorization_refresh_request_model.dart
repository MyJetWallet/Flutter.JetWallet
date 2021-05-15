import 'package:freezed_annotation/freezed_annotation.dart';

part 'authorization_refresh_request_model.freezed.dart';

@freezed
class AuthorizationRefreshRequestModel with _$AuthorizationRefreshRequestModel {
  const factory AuthorizationRefreshRequestModel({
    String? signature,
    required String refreshToken,
    required String requestTime,
  }) = _RefreshRequestModel;
}
