import 'package:freezed_annotation/freezed_annotation.dart';
import '../../key_value/model/key_value_response_model.dart';

part 'key_value_request_model.freezed.dart';
part 'key_value_request_model.g.dart';

@freezed
class KeyValueRequestModel with _$KeyValueRequestModel {
  const factory KeyValueRequestModel({
    required List<KeyValueResponseModel> keys,
  }) = _KeyValueRequestModel;

  factory KeyValueRequestModel.fromJson(Map<String, dynamic> json) =>
      _$KeyValueRequestModelFromJson(json);
}
