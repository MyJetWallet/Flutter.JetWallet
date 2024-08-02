import 'package:freezed_annotation/freezed_annotation.dart';

part 'server_time_response_model.freezed.dart';
part 'server_time_response_model.g.dart';

@freezed
class ServerTimeResponseModel with _$ServerTimeResponseModel {
  const factory ServerTimeResponseModel({
    @JsonKey(name: 'serverTime') required String time,
  }) = _ServerTimeResponseModel;

  factory ServerTimeResponseModel.fromJson(Map<String, dynamic> json) => _$ServerTimeResponseModelFromJson(json);
}
