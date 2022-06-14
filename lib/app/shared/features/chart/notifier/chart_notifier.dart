import 'package:charts/main.dart';
import 'package:charts/simple_chart.dart';
import 'package:charts/utils/data_feed_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_networking/services/chart/model/candles_request_model.dart';
import 'package:simple_networking/services/chart/model/wallet_history_request_model.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../helper/format_merge_candles_count.dart';
import '../helper/format_resolution.dart';
import '../helper/prepare_candles_from.dart';
import '../helper/time_length_from.dart';
import '../model/chart_input.dart';
import 'chart_state.dart';
import 'chart_union.dart';

class ChartNotifier extends StateNotifier<ChartState> {
  ChartNotifier({
    required this.read,
    required this.chartInput,
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
    final currentDate = DateTime.now().toLocal();
    final localCreationDate = DateTime.parse(chartInput.creationDate).toLocal();
    final dateDifference = currentDate.difference(localCreationDate).inHours;
    final showWeek = dateDifference > const Duration(days: 7).inHours;
    final showMonth = dateDifference > const Duration(days: 30).inHours;
    final showYear = dateDifference > const Duration(days: 365).inHours;

    if (chartInput.instrumentId != null) {
      fetchAssetCandles(Period.day, chartInput.instrumentId!).then(
        (_) {
          final dayCandles = state.candles[Period.day];
          if (dayCandles != null && dayCandles.isEmpty) {
            fetchAssetCandles(Period.day, chartInput.instrumentId!);
          }
          if (showWeek) {
            fetchAssetCandles(Period.week, chartInput.instrumentId!);
          }
          if (showMonth) {
            fetchAssetCandles(Period.month, chartInput.instrumentId!);
          }
          if (showYear) {
            fetchAssetCandles(Period.year, chartInput.instrumentId!);
          }
          fetchAssetCandles(Period.all, chartInput.instrumentId!);
        },
      );
    } else {
      fetchBalanceCandles(Period.day).then(
        (_) {
          final dayCandles = state.candles[Period.day];
          if (dayCandles != null && dayCandles.isEmpty) {
            fetchBalanceCandles(Period.day);
          }
          if (showWeek) fetchBalanceCandles(Period.week);
          if (showMonth) fetchBalanceCandles(Period.month);
          if (showYear) fetchBalanceCandles(Period.year);
          fetchBalanceCandles(Period.all);
        },
      );
    }
  }

  final Reader read;
  final ChartInput chartInput;

  static final _logger = Logger('ChartNotifier');

  Future<void> fetchBalanceCandles(String resolution) async {
    _logger.log(notifier, 'fetchBalanceCandles');

    final intl = read(intlPod);

    try {
      state = state.copyWith(union: const Loading());

      final model = WalletHistoryRequestModel(
        targetAsset: read(baseCurrencyPod).symbol,
        period: timeLengthFrom(resolution),
      );

      final walletHistory = await read(chartServicePod).walletHistory(
        model,
        intl.localeName,
      );
      updateCandles(candlesFrom(walletHistory.graph), resolution);
    } catch (e) {
      _logger.log(stateFlow, 'fetchBalanceCandles', e);

      updateCandles([], resolution);
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
      // TODO reconsider this
      final candles1 = candles.candles.map(
        (e) => CandleModel(
          open: e.open,
          close: e.close,
          high: e.high,
          low: e.low,
          date: e.date,
        ),
      );
      updateCandles(candles1.toList(), resolution);
    } catch (e) {
      _logger.log(stateFlow, 'fetchAssetCandles', e);

      updateCandles([], resolution);
    }
  }

  void updateCandles(List<CandleModel>? candles, String resolution) {
    _logger.log(notifier, 'updateCandles');

    if (!mounted) return;

    final currentCandles = Map.of(state.candles);
    currentCandles[resolution] = candles;

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
