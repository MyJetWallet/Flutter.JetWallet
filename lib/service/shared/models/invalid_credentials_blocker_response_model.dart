import 'package:freezed_annotation/freezed_annotation.dart';

part 'invalid_credentials_blocker_response_model.freezed.dart';
part 'invalid_credentials_blocker_response_model.g.dart';

@freezed
class InvalidCredentialsBlockerResponseModel
    with _$InvalidCredentialsBlockerResponseModel {
  const factory InvalidCredentialsBlockerResponseModel({
    required int currentAttempts,
    required int maxAttempts,
  }) = _InvalidCredentialsBlockerResponseModel;

  factory InvalidCredentialsBlockerResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$InvalidCredentialsBlockerResponseModelFromJson(json);
}
