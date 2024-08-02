import 'package:freezed_annotation/freezed_annotation.dart';

part 'delete_card_request_model.freezed.dart';
part 'delete_card_request_model.g.dart';

@freezed
class DeleteCardRequestModel with _$DeleteCardRequestModel {
  const factory DeleteCardRequestModel({
    required String cardId,
  }) = _DeleteCardRequestModel;

  factory DeleteCardRequestModel.fromJson(Map<String, dynamic> json) => _$DeleteCardRequestModelFromJson(json);
}
