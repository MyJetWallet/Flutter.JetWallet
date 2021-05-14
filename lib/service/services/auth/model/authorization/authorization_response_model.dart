import 'package:freezed_annotation/freezed_annotation.dart';

part 'authorization_response_model.freezed.dart';

@freezed
class AuthorizationResponseModel with _$AuthorizationResponseModel {
  const factory AuthorizationResponseModel({
    required String token,
  }) = _AuthorizationResponseModel;
}
