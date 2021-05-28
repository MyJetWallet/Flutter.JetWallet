import 'package:charts/utils/data_feed_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../service/services/charts/model/get_candles/candles_request_model.dart';
import '../../../../service/services/charts/model/get_candles/candles_response_model.dart';
import '../../../../service/services/charts/service/charts_service.dart';
import 'state/charts_state.dart';

extension on DateTime {
  DateTime roundDown({Duration delta = const Duration(seconds: 1)}) {
    return DateTime.fromMillisecondsSinceEpoch(
        millisecondsSinceEpoch - millisecondsSinceEpoch % delta.inMilliseconds,
        isUtc: true);
  }
}

class ChartNotifier extends StateNotifier<ChartsState> {
  ChartNotifier({
    required this.chartsService,
  }) : super(
          const ChartsState(candles: []),
        );

  final ChartsService chartsService;

  Future<void> getCandles(String resolution, String instrumentId) async {
    final toDate = DateTime.now().toUtc();

    final calculatedHistoryDepth =
        DataFeedUtil.calculateHistoryDepth(resolution);

    final fromDate =
        toDate.subtract(calculatedHistoryDepth.intervalBackDuration);

    final model = CandlesRequestModel(
      instrumentId: instrumentId,
      bidOrAsk: 0,
      fromDate: fromDate.roundDown().millisecondsSinceEpoch,
      toDate: toDate.roundDown().millisecondsSinceEpoch,
      candleType: DataFeedUtil.parseCandleType(resolution).index,
    );

    final candles = await chartsService.getCandles(model);

    state = state.copyWith(candles: candles.candles);
  }

  void initCandles(List<CandleModel> candles) {
    state = state.copyWith(candles: candles);
  }
}
