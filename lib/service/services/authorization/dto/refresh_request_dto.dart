import 'package:json_annotation/json_annotation.dart';

import '../model/authorization_refresh_request_model.dart';

part 'refresh_request_dto.g.dart';

@JsonSerializable()
class RefreshRequestDto {
  RefreshRequestDto({
    this.signature,
    required this.refreshToken,
    required this.requestTime,
  });

  factory RefreshRequestDto.fromModel(AuthorizationRefreshRequestModel model) {
    return RefreshRequestDto(
      refreshToken: model.refreshToken,
      signature: model.signature,
      requestTime: model.requestTime,
    );
  }

  Map<String, dynamic> toJson() => _$RefreshRequestDtoToJson(this);

  final String? signature;
  final String refreshToken;
  final String requestTime;
}
