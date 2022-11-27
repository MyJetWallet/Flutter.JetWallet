import 'package:freezed_annotation/freezed_annotation.dart';

part 'authentication_response_model.freezed.dart';
part 'authentication_response_model.g.dart';

@freezed
class AuthenticationResponseModel with _$AuthenticationResponseModel {
  const factory AuthenticationResponseModel({
    required String token,
    required String refreshToken,
  }) = _AuthenticationModel;

  factory AuthenticationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseModelFromJson(json);
}
