import 'package:freezed_annotation/freezed_annotation.dart';

part 'candles_response_model.freezed.dart';

part 'candles_response_model.g.dart';

@freezed
class CandlesResponseModel with _$CandlesResponseModel {
  const factory CandlesResponseModel({
    required List<CandleModel> candles,
  }) = _CandlesResponseModel;

  factory CandlesResponseModel.fromList(List<dynamic> list) {
    return CandlesResponseModel(
      candles: list
          .map((e) => CandleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

@freezed
class CandleModel with _$CandleModel {
  const factory CandleModel({
    @JsonKey(name: 'd') required int date,
    @JsonKey(name: 'o') required double open,
    @JsonKey(name: 'c') required double close,
    @JsonKey(name: 'h') required double high,
    @JsonKey(name: 'l') required double low,
  }) = _CandleModel;

  factory CandleModel.fromJson(Map<String, dynamic> json) =>
      _$CandleModelFromJson(json);
}
