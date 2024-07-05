import 'package:freezed_annotation/freezed_annotation.dart';

part 'news_request_model.freezed.dart';
part 'news_request_model.g.dart';

@freezed
class NewsRequestModel with _$NewsRequestModel {
  const factory NewsRequestModel({
    String? assetId,
    @JsonKey(name: 'lastSeen') String? lastDate,
    @JsonKey(name: 'take') int? batchSize,
    @JsonKey(name: 'lang') required String language,
  }) = _NewsRequestModel;

  factory NewsRequestModel.fromJson(Map<String, dynamic> json) => _$NewsRequestModelFromJson(json);
}
