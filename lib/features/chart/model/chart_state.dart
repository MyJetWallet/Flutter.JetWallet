import 'package:charts/simple_chart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'chart_union.dart';

part 'chart_state.freezed.dart';

@freezed
class ChartState with _$ChartState {
  const factory ChartState({
    CandleModel? selectedCandle,
    required Map<String, List<CandleModel>?> candles,
    required ChartType type,
    required String resolution,
    @Default(Loading()) ChartUnion union,
  }) = _ChartState;
}
