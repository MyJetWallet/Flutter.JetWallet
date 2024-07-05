import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_check_request_model.freezed.dart';
part 'card_check_request_model.g.dart';

@freezed
class CardCheckRequestModel with _$CardCheckRequestModel {
  const factory CardCheckRequestModel({
    required String cardId,
  }) = _CardCheckRequestModel;

  factory CardCheckRequestModel.fromJson(Map<String, dynamic> json) => _$CardCheckRequestModelFromJson(json);
}
