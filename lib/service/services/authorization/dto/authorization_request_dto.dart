import 'package:json_annotation/json_annotation.dart';

import '../model/authorization_request_model.dart';

part 'authorization_request_dto.g.dart';

@JsonSerializable()
class AuthorizationRequestDto {
  AuthorizationRequestDto({
    required this.authToken,
    this.publicKeyPem,
  });

  factory AuthorizationRequestDto.fromModel(AuthorizationRequestModel model) {
    return AuthorizationRequestDto(
      authToken: model.authToken,
      publicKeyPem: model.publicKeyPem,
    );
  }

  Map<String, dynamic> toJson() => _$AuthorizationRequestDtoToJson(this);

  final String authToken;
  final String? publicKeyPem;
}
