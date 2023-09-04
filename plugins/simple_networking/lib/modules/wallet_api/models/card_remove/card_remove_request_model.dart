import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_remove_request_model.freezed.dart';
part 'card_remove_request_model.g.dart';

@freezed
class CardRemoveRequestModel with _$CardRemoveRequestModel {
  const factory CardRemoveRequestModel({
    String? cardId,
  }) = _CardRemoveRequestModel;

  factory CardRemoveRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CardRemoveRequestModelFromJson(json);
}
