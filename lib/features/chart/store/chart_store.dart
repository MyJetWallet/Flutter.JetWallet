import 'dart:async';

import 'package:charts/main.dart';
import 'package:charts/simple_chart.dart';
import 'package:charts/utils/data_feed_util.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/local_cache/local_cache_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/chart/helper/format_merge_candles_count.dart';
import 'package:jetwallet/features/chart/helper/format_resolution.dart';
import 'package:jetwallet/features/chart/helper/prepare_candles_from.dart';
import 'package:jetwallet/features/chart/helper/time_length_from.dart';
import 'package:jetwallet/features/chart/model/chart_input.dart';
import 'package:jetwallet/features/chart/model/chart_union.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/candles_api/models/candles_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/wallet_history/wallet_history_request_model.dart';

part 'chart_store.g.dart';

class ChartStore extends _ChartStoreBase with _$ChartStore {
  ChartStore(super.chartInput);

  static _ChartStoreBase of(BuildContext context) =>
      Provider.of<ChartStore>(context, listen: false);
}

abstract class _ChartStoreBase with Store {
  _ChartStoreBase(this.chartInput) {
    try {
      final currentDate = DateTime.now().toLocal();
      final localCreationDate =
          DateTime.parse(chartInput.creationDate).toLocal();
      final dateDifference = currentDate.difference(localCreationDate).inHours;
      final showWeek = dateDifference > const Duration(days: 7).inHours;
      final showMonth = dateDifference > const Duration(days: 30).inHours;
      final showYear = dateDifference > const Duration(days: 365).inHours;

      if (chartInput.instrumentId != null) {
        getDataFromCache();

        fetchAssetCandles(Period.day, chartInput.instrumentId!).then(
          (_) {
            final dayCandles = candles[Period.day];
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
            final dayCandles = candles[Period.day];
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
    } catch (e) {
      print(e);
    }
  }

  final ChartInput chartInput;

  static final _logger = Logger('ChartStore');

  @observable
  CandleModel? selectedCandle;

  @observable
  Map<String, List<CandleModel>?> candles = {
    Period.day: null,
    Period.week: null,
    Period.month: null,
    Period.year: null,
    Period.all: null,
  };

  @observable
  ChartType type = ChartType.line;

  @observable
  String resolution = Period.day;

  @observable
  bool canFetch = true;

  @observable
  ChartUnion union = const ChartUnion.loading();

  @action
  Future<void> getDataFromCache() async {
    if (chartInput.instrumentId != null) {
      final getDataFromCache =
          await getIt<LocalCacheService>().getChart(chartInput.instrumentId!);

      if (getDataFromCache != null) {
        candles = getDataFromCache.candle;
        union = const Candles();
      }
    }
  }

  @action
  Future<void> fetchBalanceCandles(
    String resolution, {
    bool isLocal = false,
  }) async {
    _logger.log(notifier, 'fetchBalanceCandles');

    print('canFetch: $canFetch');

    try {
      if (!isLocal) {
        union = const ChartUnion.loading();
      } else {
        if (!canFetch) {
          return;
        }
        canFetch = false;
        Timer(
          const Duration(seconds: 2),
          () {
            canFetch = true;
          },
        );
      }

      final model = WalletHistoryRequestModel(
        targetAsset: sSignalRModules.baseCurrency.symbol,
        period: timeLengthFrom(resolution),
      );

      final response = await sNetwork.getWalletModule().getWalletHistory(model);

      response.pick(
        onData: (data) async {
          updateCandles(
            candlesFrom(data.graph),
            resolution,
          );
        },
        onError: (e) {
          _logger.log(stateFlow, 'fetchBalanceCandles', e);
          print('onError fetchBalanceCandles');

          //updateCandles([], resolution);
        },
      );
    } catch (e) {
      _logger.log(stateFlow, 'fetchBalanceCandles', e);

      print(e);

      //updateCandles([], resolution);
    }
  }

  @action
  Future<void> fetchAssetCandles(String resolution, String instrumentId) async {
    _logger.log(notifier, 'fetchAssetCandles');

    try {
      if (union != const ChartUnion.candles()) {
        union = const ChartUnion.loading();
      }

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

      final candlesResponse =
          await sNetwork.getCandlesModule().getCandles(model);

      candlesResponse.pick(
        onData: (candles) {
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
        },
        onError: (e) {
          _logger.log(stateFlow, 'fetchAssetCandles', e);
          updateCandles([], resolution);
        },
      );
    } catch (e) {
      _logger.log(stateFlow, 'fetchAssetCandles', e);

      updateCandles([], resolution);
    }
  }

  @action
  void updateCandles(List<CandleModel>? _candles, String resolution) {
    _logger.log(notifier, 'updateCandles');

    final currentCandles = Map.of(candles);
    currentCandles[resolution] = _candles;

    candles = currentCandles;
    union = const Candles();

    if (chartInput.instrumentId != null) {
      getIt<LocalCacheService>().saveChart(
        chartInput.instrumentId!,
        currentCandles,
      );
    }
  }

  @action
  void updateChartType(ChartType _type) {
    _logger.log(notifier, 'updateChartType');

    type = _type;
  }

  @action
  void updateSelectedCandle(CandleModel? _selectedCandle) {
    _logger.log(notifier, 'updateSelectedCandle');

    selectedCandle = _selectedCandle;
  }

  @action
  void updateResolution(String _resolution) {
    _logger.log(notifier, 'updateResolution');

    // TODO: why?))
    showAnimation = true;
    resolution = _resolution;
  }
}
