import 'package:freezed_annotation/freezed_annotation.dart';

part 'last_candles_request_model.freezed.dart';
part 'last_candles_request_model.g.dart';

@freezed
class LastCandlesRequestModel with _$LastCandlesRequestModel {
  const factory LastCandlesRequestModel({
    @JsonKey(ignore: true) String? instrumentId,
    @JsonKey(ignore: true) int? type,
    required int bidOrAsk,
    required int amount,
    required int mergeCandlesCount,
  }) = _LastCandlesRequestModel;

  factory LastCandlesRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LastCandlesRequestModelFromJson(json);
}
