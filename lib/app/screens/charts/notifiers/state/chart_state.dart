import 'package:charts/entity/k_line_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'chart_union.dart';

part 'chart_state.freezed.dart';

@freezed
class ChartState with _$ChartState {
  const factory ChartState({
    required List<CandleModel> candles,
    @Default(Loading()) ChartUnion union,
  }) = _ChartState;
}
