import 'package:freezed_annotation/freezed_annotation.dart';

part 'card_add_response_model.freezed.dart';
part 'card_add_response_model.g.dart';

@freezed
class CardAddResponseModel with _$CardAddResponseModel {
  const factory CardAddResponseModel({
    String? rejectDetail,
  }) = _CardAddResponseModel;

  factory CardAddResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CardAddResponseModelFromJson(json);
}
