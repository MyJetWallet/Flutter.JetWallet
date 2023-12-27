import 'package:freezed_annotation/freezed_annotation.dart';

part 'simple_card_terminate_request_model.freezed.dart';
part 'simple_card_terminate_request_model.g.dart';

@freezed
class SimpleCardTerminateRequestModel with _$SimpleCardTerminateRequestModel {
  const factory SimpleCardTerminateRequestModel({
    required String cardId,
  }) = _SimpleCardTerminateRequestModel;

  factory SimpleCardTerminateRequestModel.fromJson(Map<String, dynamic> json) =>
      _$SimpleCardTerminateRequestModelFromJson(json);
}
