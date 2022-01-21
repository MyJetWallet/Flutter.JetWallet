import 'package:charts/simple_chart.dart';
import 'package:charts/utils/data_feed_util.dart';
import 'package:flutter/animation.dart';
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
    required this.animationController,
  }) : super(
          const ChartState(
            candles: [],
            type: ChartType.line,
            resolution: Period.day,
          ),
        );

  final Reader read;
  final AnimationController? animationController;

  static final _logger = Logger('ChartNotifier');

  Future<void> fetchBalanceCandles(String resolution) async {
    _logger.log(notifier, 'fetchBalanceCandles');

    try {
      _updateResolution(resolution);
      state = state.copyWith(union: const Loading());

      final model = WalletHistoryRequestModel(
        targetAsset: read(baseCurrencyPod).symbol,
        period: timeLengthFrom(resolution),
      );

      final walletHistory = await read(chartServicePod).walletHistory(model);
      updateCandles(candlesFrom(walletHistory.graph));
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
      updateCandles(candles.candles);
    } catch (e) {
      _logger.log(stateFlow, 'fetchAssetCandles', e);

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

    print('________________________${animationController}');
    animationController?.reset();
    animationController?.forward();
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
