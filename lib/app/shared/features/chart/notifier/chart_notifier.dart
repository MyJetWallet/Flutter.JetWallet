import 'package:charts/main.dart';
import 'package:charts/simple_chart.dart';
import 'package:charts/utils/data_feed_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/chart/model/candles_request_model.dart';
import '../../../../../service/services/chart/model/wallet_history_request_model.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../helper/format_merge_candles_count.dart';
import '../helper/format_resolution.dart';
import '../helper/prepare_candles_from.dart';
import '../helper/time_length_from.dart';
import 'chart_state.dart';
import 'chart_union.dart';

class ChartNotifier extends StateNotifier<ChartState> {
  ChartNotifier({
    required this.read,
    required this.instrumentId,
  }) : super(
          const ChartState(
            candles: {
              Period.day: null,
              Period.week: null,
              Period.month: null,
              Period.year: null,
              Period.all: null,
            },
            type: ChartType.line,
            resolution: Period.day,
          ),
        ) {
    if (instrumentId != null) {
      fetchAssetCandles(Period.day, instrumentId!).then(
        (_) {
          final dayCandles = state.candles[Period.day];
          if (dayCandles != null && dayCandles.isEmpty) {
            fetchAssetCandles(Period.day, instrumentId!);
          }
          fetchAssetCandles(Period.week, instrumentId!);
          fetchAssetCandles(Period.month, instrumentId!);
          fetchAssetCandles(Period.year, instrumentId!);
          fetchAssetCandles(Period.all, instrumentId!);
        },
      );
    } else {
      fetchBalanceCandles(Period.day).then(
        (_) {
          final dayCandles = state.candles[Period.day];
          if (dayCandles != null && dayCandles.isEmpty) {
            fetchBalanceCandles(Period.day);
          }
          fetchBalanceCandles(Period.week);
          fetchBalanceCandles(Period.month);
          fetchBalanceCandles(Period.year);
          fetchBalanceCandles(Period.all);
        },
      );
    }
  }

  final Reader read;
  final String? instrumentId;

  static final _logger = Logger('ChartNotifier');

  Future<void> fetchBalanceCandles(String resolution) async {
    _logger.log(notifier, 'fetchBalanceCandles');

    try {
      state = state.copyWith(union: const Loading());

      final model = WalletHistoryRequestModel(
        targetAsset: read(baseCurrencyPod).symbol,
        period: timeLengthFrom(resolution),
      );

      final walletHistory = await read(chartServicePod).walletHistory(model);
      updateCandles(candlesFrom(walletHistory.graph), resolution);
    } catch (e) {
      _logger.log(stateFlow, 'fetchBalanceCandles', e);

      updateCandles(null, resolution);
    }
  }

  Future<void> fetchAssetCandles(String resolution, String instrumentId) async {
    _logger.log(notifier, 'fetchAssetCandles');

    try {
      state = state.copyWith(union: const Loading());

      final toDate = DateTime.now().toUtc();
      final depth = DataFeedUtil.calculateHistoryDepth(resolution);
      final fromDate = toDate.subtract(depth.intervalBackDuration);

      final model = CandlesRequestModel(
        candleId: instrumentId,
        type: timeFrameFrom(resolution),
        bidOrAsk: 0,
        fromDate: fromDate.millisecondsSinceEpoch,
        toDate: toDate.millisecondsSinceEpoch,
        mergeCandlesCount: mergeCandlesCountFrom(resolution),
      );

      final candles = await read(chartServicePod).candles(model);
      updateCandles(candles.candles, resolution);
    } catch (e) {
      _logger.log(stateFlow, 'fetchAssetCandles', e);

      updateCandles(null, resolution);
    }
  }

  void updateCandles(List<CandleModel>? candles, String resolution) {
    _logger.log(notifier, 'updateCandles');

    if (!mounted) return;

    final currentCandles = Map.of(state.candles);
    currentCandles[resolution] = candles;

    showAnimation = true;
    state = state.copyWith(
      candles: currentCandles,
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

  void updateResolution(String resolution) {
    _logger.log(notifier, 'updateResolution');

    showAnimation = true;
    state = state.copyWith(resolution: resolution);
  }
}
