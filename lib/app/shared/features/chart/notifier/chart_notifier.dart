import 'package:charts/main.dart';
import 'package:charts/simple_chart.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../shared/logging/levels.dart';
import 'chart_state.dart';
import 'chart_union.dart';

class ChartNotifier extends StateNotifier<ChartState> {
  ChartNotifier({
    required this.read,
  }) : super(
          const ChartState(
            candles: {},
            type: ChartType.line,
            resolution: Period.day,
          ),
        );

  final Reader read;

  static final _logger = Logger('ChartNotifier');

  Future<void> fetchBalanceCandles(String resolution) async {
    _logger.log(notifier, 'fetchBalanceCandles');

    try {
      _updateResolution(resolution);
      showAnimation = true;
      // state = state.copyWith(union: const Loading());
      //
      // final model = WalletHistoryRequestModel(
      //   targetAsset: read(baseCurrencyPod).symbol,
      //   period: timeLengthFrom(resolution),
      // );
      //
      // final walletHistory = await read(chartServicePod).walletHistory(model);
      // updateCandles(candlesFrom(walletHistory.graph));
    } catch (e) {
      _logger.log(stateFlow, 'fetchBalanceCandles', e);

      state = state.copyWith(
        union: const Error('Error loading chart'),
      );
    }
  }

  Future<void> fetchAssetCandles(String resolution, String instrumentId) async {
    _logger.log(notifier, 'fetchAssetCandles');

    try {
      _updateResolution(resolution);
      showAnimation = true;
      // state = state.copyWith(union: const Loading());
      //
      // final toDate = DateTime.now().toUtc();
      // final depth = DataFeedUtil.calculateHistoryDepth(resolution);
      // final fromDate = toDate.subtract(depth.intervalBackDuration);
      //
      // final model = CandlesRequestModel(
      //   candleId: instrumentId,
      //   type: timeFrameFrom(resolution),
      //   bidOrAsk: 0,
      //   fromDate: fromDate.millisecondsSinceEpoch,
      //   toDate: toDate.millisecondsSinceEpoch,
      //   mergeCandlesCount: mergeCandlesCountFrom(resolution),
      // );
      //
      // final candles = await read(chartServicePod).candles(model);
      // updateCandles(candles.candles);
    } catch (e) {
      _logger.log(stateFlow, 'fetchAssetCandles', e);

      state = state.copyWith(
        union: const Error('Error loading chart'),
      );
    }
  }

  void updateCandles(Map<String, List<CandleModel>> candles) {
    _logger.log(notifier, 'updateCandles');

    showAnimation = true;

    if (!mounted) return;

    state = state.copyWith(
      candles: candles,
      union: const Candles(),
    );
  }

  void updateChartType(ChartType type) {
    _logger.log(notifier, 'updateChartType');

    state = state.copyWith(type: type);
  }

  void updateSelectedCandle(CandleModel? selectedCandle) {
    _logger.log(notifier, 'updateSelectedCandle');

    state = state.copyWith(selectedCandle: selectedCandle);
  }

  void _updateResolution(String resolution) {
    state = state.copyWith(resolution: resolution);
  }
}
