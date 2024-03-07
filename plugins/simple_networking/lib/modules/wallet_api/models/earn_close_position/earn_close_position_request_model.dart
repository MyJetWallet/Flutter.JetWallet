import 'package:freezed_annotation/freezed_annotation.dart';

part 'earn_close_position_request_model.freezed.dart';
part 'earn_close_position_request_model.g.dart';

@freezed
class EarnColosePositionRequestModel with _$EarnColosePositionRequestModel {
  const factory EarnColosePositionRequestModel({
    required String requestId,
    required String positionId,
  }) = _EarnColosePositionRequestModel;

  factory EarnColosePositionRequestModel.fromJson(Map<String, dynamic> json) =>
      _$EarnColosePositionRequestModelFromJson(json);
}
