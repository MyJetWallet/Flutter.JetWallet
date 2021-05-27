import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../../service/services/charts/model/get_candles/candles_response_model.dart';

part 'charts_state.freezed.dart';

@freezed
class ChartsState with _$ChartsState {
  const factory ChartsState({
    required List<CandleModel> candles,
  }) = _ChartsState;
}


