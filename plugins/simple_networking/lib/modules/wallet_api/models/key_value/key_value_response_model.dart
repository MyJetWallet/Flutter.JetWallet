import 'package:freezed_annotation/freezed_annotation.dart';

part 'key_value_response_model.freezed.dart';
part 'key_value_response_model.g.dart';

@freezed
class KeyValueResponseModel with _$KeyValueResponseModel {
  const factory KeyValueResponseModel({
    required String key,
    required String value,
  }) = _KeyValueResponseModel;

  factory KeyValueResponseModel.fromJson(Map<String, dynamic> json) => _$KeyValueResponseModelFromJson(json);
}
