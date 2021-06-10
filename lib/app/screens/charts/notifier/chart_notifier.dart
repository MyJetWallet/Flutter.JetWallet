import 'package:charts/entity/candle_model.dart';
import 'package:charts/entity/candle_type_enum.dart';
import 'package:charts/utils/data_feed_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/chart/model/candles_request_model.dart';
import '../../../../service/services/chart/service/chart_service.dart';
import '../helpers/round_down_date.dart';
import 'state/chart_state.dart';
import 'state/chart_union.dart';

class ChartNotifier extends StateNotifier<ChartState> {
  ChartNotifier({
    required this.chartService,
  }) : super(
          const ChartState(
            candles: [],
            type: ChartType.candle,
            resolution: 'm',
          ),
        );

  final ChartService chartService;

  Future<void> fetchCandles(String resolution, String instrumentId) async {
    updateResolution(resolution);
    state = state.copyWith(union: const Loading());

    final toDate = DateTime.now().toUtc();
    final depth = DataFeedUtil.calculateHistoryDepth(resolution);
    final fromDate = toDate.subtract(depth.intervalBackDuration);

    final model = CandlesRequestModel(
      instrumentId: instrumentId,
      bidOrAsk: 0,
      fromDate: roundDown(fromDate).millisecondsSinceEpoch,
      toDate: roundDown(toDate).millisecondsSinceEpoch,
      candleType: DataFeedUtil.parseCandleType(resolution).index,
    );

    try {
      final candles = await chartService.candles(model);
      updateCandles(candles.candles);
    } catch (e) {
      state = state.copyWith(
        union: const Error('Error loading chart'),
      );
    }
  }

  void updateCandles(List<CandleModel> candles) {
    state = state.copyWith(
      candles: candles,
      union: const Candles(),
    );
  }

  void updateChartType(ChartType type) {
    state = state.copyWith(type: type);
  }

  void updateResolution(String resolution) {
    state = state.copyWith(resolution: resolution);
  }
}
