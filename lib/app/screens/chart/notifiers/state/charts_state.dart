import 'package:charts/entity/k_line_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'charts_union.dart';

part 'charts_state.freezed.dart';

@freezed
class ChartsState with _$ChartsState {
  const factory ChartsState({
    required List<CandleModel> candles,
    @Default(Loading()) ChartsUnion union,
  }) = _ChartsState;
}
