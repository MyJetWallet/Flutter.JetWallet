import 'package:json_annotation/json_annotation.dart';

import '../../model/wallet/server_time_model.dart';

part 'server_time_response_dto.g.dart';

@JsonSerializable()
class ServerTimeDto {
  ServerTimeDto({
    required this.now,
  });

  factory ServerTimeDto.fromJson(Map<String, dynamic> json) =>
      _$ServerTimeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ServerTimeDtoToJson(this);

  ServerTimeModel toModel() => ServerTimeModel(
        now: now,
      );

  final double now;
}
