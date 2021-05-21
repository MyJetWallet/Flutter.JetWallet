import 'package:json_annotation/json_annotation.dart';

part 'response_dto.g.dart';

@JsonSerializable()
class ResponseDto<T> {
  ResponseDto({
    required this.result,
    required this.data,
  });

  factory ResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResponseDtoToJson(this);

  final String result;
  @JsonKey(fromJson: _dataFromJson, toJson: _dataToJson)
  final T data;
}

T _dataFromJson<T>(Map<String, dynamic> input) => input['data'] as T;

Map<String, dynamic> _dataToJson<T>(T input) => {'data': input};
