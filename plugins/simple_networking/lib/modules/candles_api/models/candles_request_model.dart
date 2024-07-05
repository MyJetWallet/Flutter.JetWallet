import 'package:freezed_annotation/freezed_annotation.dart';

part 'candles_request_model.freezed.dart';
part 'candles_request_model.g.dart';

@freezed
class CandlesRequestModel with _$CandlesRequestModel {
  const factory CandlesRequestModel({
    @JsonKey(name: 'instruction') String? candleId,
    @JsonKey(includeFromJson: true) int? type,
    required int bidOrAsk,
    required int fromDate,
    required int toDate,
    required int mergeCandlesCount,
  }) = _CandlesRequestModel;

  factory CandlesRequestModel.fromJson(Map<String, dynamic> json) => _$CandlesRequestModelFromJson(json);
}
