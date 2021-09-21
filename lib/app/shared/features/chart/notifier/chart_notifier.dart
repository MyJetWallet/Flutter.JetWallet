import 'package:charts/entity/candle_model.dart';
import 'package:charts/entity/candle_type_enum.dart';
import 'package:charts/entity/resolution_string_enum.dart';
import 'package:charts/utils/data_feed_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/chart/model/candles_request_model.dart';
import '../../../../../service/services/chart/service/chart_service.dart';
import '../../../../../shared/logging/levels.dart';
import '../helper/format_merge_candles_count.dart';
import '../helper/format_resolution.dart';
import 'chart_state.dart';
import 'chart_union.dart';

class ChartNotifier extends StateNotifier<ChartState> {
  ChartNotifier({
    required this.chartService,
  }) : super(
          const ChartState(
            candles: [],
            type: ChartType.line,
            resolution: Period.day,
          ),
        );

  final ChartService chartService;

  static final _logger = Logger('ChartNotifier');

  Future<void> fetchCandles(String resolution, String instrumentId) async {
    _logger.log(notifier, 'fetchCandles');

    try {
      updateResolution(resolution);
      state = state.copyWith(union: const Loading());

      final toDate = DateTime.now().toUtc();
      final depth = DataFeedUtil.calculateHistoryDepth(resolution);
      final fromDate = toDate.subtract(depth.intervalBackDuration);

      final model = CandlesRequestModel(
        instrumentId: instrumentId,
        type: timeFrameFrom(resolution),
        bidOrAsk: 0,
        fromDate: fromDate.millisecondsSinceEpoch,
        toDate: toDate.millisecondsSinceEpoch,
        mergeCandlesCount: mergeCandlesCountFrom(resolution),
      );

      final candles = await chartService.candles(model);
      updateCandles(candles.candles);
    } catch (e) {
      _logger.log(stateFlow, 'fetchCandles', e);

      state = state.copyWith(
        union: const Error('Error loading chart'),
      );
    }
  }

  void updateCandles(List<CandleModel> candles) {
    _logger.log(notifier, 'updateCandles');

    state = state.copyWith(
      candles: candles,
      union: const Candles(),
    );
  }

  void updateChartType(ChartType type) {
    _logger.log(notifier, 'updateChartType');

    state = state.copyWith(type: type);
  }

  void updateResolution(String resolution) {
    _logger.log(notifier, 'updateResolution');

    state = state.copyWith(resolution: resolution);
  }

  void updateSelectedCandle(CandleModel? selectedCandle) {
    _logger.log(notifier, 'updateSelectedCandle');

    state = state.copyWith(selectedCandle: selectedCandle);
  }
}
