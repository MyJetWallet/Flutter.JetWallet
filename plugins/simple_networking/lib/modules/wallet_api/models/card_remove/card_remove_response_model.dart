import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_remove_response_model.freezed.dart';
part 'card_remove_response_model.g.dart';

@freezed
class CardRemoveResponseModel with _$CardRemoveResponseModel {
  const factory CardRemoveResponseModel({
    String? rejectDetail,
  }) = _CardRemoveResponseModel;

  factory CardRemoveResponseModel.fromJson(Map<String, dynamic> json) => _$CardRemoveResponseModelFromJson(json);
}
