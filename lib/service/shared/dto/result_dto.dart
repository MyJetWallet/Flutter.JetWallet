import 'package:json_annotation/json_annotation.dart';

part 'result_dto.g.dart';

@JsonSerializable()
class ResultDto {
  ResultDto({
    required this.result,
  });

  factory ResultDto.fromJson(Map<String, dynamic> json) =>
      _$ResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResultDtoToJson(this);

  final String result;
}
