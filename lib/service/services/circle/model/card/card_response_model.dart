import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_response_model.freezed.dart';
part 'card_response_model.g.dart';

@freezed
class CardResponseModel with _$CardResponseModel {
  const factory CardResponseModel({
    required String name,
  }) = _CardResponseModel;

  factory CardResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CardResponseModelFromJson(json);
}
