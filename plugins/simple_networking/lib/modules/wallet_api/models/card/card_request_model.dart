import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_request_model.freezed.dart';
part 'card_request_model.g.dart';

@freezed
class CardRequestModel with _$CardRequestModel {
  const factory CardRequestModel({
    required String cardId,
  }) = _CardRequestModel;

  factory CardRequestModel.fromJson(Map<String, dynamic> json) => _$CardRequestModelFromJson(json);
}
