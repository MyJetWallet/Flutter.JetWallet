import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_request_model.freezed.dart';
part 'news_request_model.g.dart';

@freezed
class NewsRequestModel with _$NewsRequestModel {
  const factory NewsRequestModel({
    required String lastSeen,
    @JsonKey(name: 'lang') required String language,
    @JsonKey(name: 'take') required int amount,
  }) = _NewsRequestModel;

  factory NewsRequestModel.fromJson(Map<String, dynamic> json) =>
      _$NewsRequestModelFromJson(json);
}
