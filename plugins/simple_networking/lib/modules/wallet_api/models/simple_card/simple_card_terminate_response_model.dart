import 'package:freezed_annotation/freezed_annotation.dart';

part 'simple_card_terminate_response_model.freezed.dart';
part 'simple_card_terminate_response_model.g.dart';

@freezed
class SimpleCardTerminateResponseModel with _$SimpleCardTerminateResponseModel {
  const factory SimpleCardTerminateResponseModel({
    required String cardId,
  }) = _SimpleCardTerminateResponseModel;

  factory SimpleCardTerminateResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SimpleCardTerminateResponseModelFromJson(json);
}
