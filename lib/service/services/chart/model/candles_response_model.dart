import 'package:charts/simple_chart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'candles_response_model.freezed.dart';

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
