import 'package:freezed_annotation/freezed_annotation.dart';

part 'authorization_request_model.freezed.dart';

@freezed
class AuthorizationRequestModel with _$AuthorizationRequestModel {
  const factory AuthorizationRequestModel({
    required String token,
    String? publicKeyPem,
  }) = _AuthorizationRequestModel;
}
