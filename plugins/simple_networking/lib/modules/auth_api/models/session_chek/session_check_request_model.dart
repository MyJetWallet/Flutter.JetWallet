import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_check_request_model.freezed.dart';

part 'session_check_request_model.g.dart';

@freezed
class SessionCheckRequestModel with _$SessionCheckRequestModel {
  const factory SessionCheckRequestModel() = _SessionCheckRequestModel;

  factory SessionCheckRequestModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$SessionCheckRequestModelFromJson(json);
}
