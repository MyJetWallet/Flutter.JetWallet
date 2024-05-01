import 'package:charts/simple_chart.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/modules/candles_api/models/candles_request_model.dart';

import '../../../../core/di/di.dart';
import '../../../../core/services/simple_networking/simple_networking.dart';
import '../../helpers/chart_resolution_helper.dart';
import '../dashboard/invest_new_store.dart';

part 'invest_chart_store.g.dart';

@lazySingleton
class InvestChartStore = _InvestChartStoreBase with _$InvestChartStore;

abstract class _InvestChartStoreBase with Store {
  _InvestChartStoreBase() {
    loader = StackLoaderStore();
  }

  @observable
  StackLoaderStore? loader;

  @observable
  List<CandlesWithIdModel> candlesList = [];

  @observable
  List<CandlesWithIdModel> candlesFull1List = [];

  @observable
  List<CandlesWithIdModel> candlesFull2List = [];

  @observable
  List<CandlesWithIdModel> candlesFull3List = [];

  @observable
  List<CandlesWithIdModel> candlesFull4List = [];

  @action
  List<CandleModel> getAssetCandles(String instrumentId) {
    final candleAsset = candlesList.where((element) => element.instrumentId == instrumentId).toList();
    if (candleAsset.isNotEmpty) {
      final price = getIt<InvestDashboardStore>().getPendingPriceBySymbol(instrumentId);
      final lastCandle = CandleModel(
        open: price.toDouble(),
        close: price.toDouble(),
        high: price.toDouble(),
        low: price.toDouble(),
        date: DateTime.now().millisecondsSinceEpoch,
      );

      return [
        lastCandle,
        ...candleAsset[0].candles,
      ];
    } else {
      fetchAssetCandles(instrumentId);

      return [];
    }
  }

  @action
  Future<List<CandleModel>> fetchAssetCandles(String instrumentId) async {
    try {
      final toDate = DateTime.now().toUtc();
      final fromDate = toDate.subtract(const Duration(hours: 24));
      var candlesToReturn = <CandleModel>[];

      final model = CandlesRequestModel(
        candleId: instrumentId,
        type: Timeframe.day,
        bidOrAsk: 0,
        fromDate: fromDate.millisecondsSinceEpoch,
        toDate: toDate.millisecondsSinceEpoch,
        mergeCandlesCount: 1,
      );

      final candlesResponse = await sNetwork.getCandlesModule().getCandles(model);

      candlesResponse.pick(
        onData: (candles) {
          final candles1 = candles.candles
              .map(
                (e) => CandleModel(
                  open: e.open,
                  close: e.close,
                  high: e.high,
                  low: e.low,
                  date: e.date,
                ),
              )
              .toList();

          candlesList.add(
            CandlesWithIdModel(
              instrumentId: instrumentId,
              candles: candles1,
            ),
          );

          candlesToReturn = candles1;
        },
        onError: (e) {},
      );

      return candlesToReturn;
    } catch (e) {
      return [];
    }
  }

  @action
  Future<List<CandleModel>> getAssetCandlesFull(String instrument, String instrumentId) async {
    final investNewStore = getIt.get<InvestNewStore>();
    final candlesFullList = investNewStore.chartInterval == 0
        ? candlesFull1List
        : investNewStore.chartInterval == 1
            ? candlesFull2List
            : investNewStore.chartInterval == 2
                ? candlesFull3List
                : candlesFull4List;
    final candleAsset = candlesFullList.where((element) => element.instrumentId == instrument).toList();
    if (candleAsset.isNotEmpty) {
      final price = getIt<InvestDashboardStore>().getPendingPriceBySymbol(instrumentId);
      final lastCandle = CandleModel(
        open: price.toDouble(),
        close: price.toDouble(),
        high: price.toDouble(),
        low: price.toDouble(),
        date: DateTime.now().millisecondsSinceEpoch,
      );

      return [
        ...candleAsset[0].candles,
        lastCandle,
      ];
    } else {
      final fetchedCandles = await fetchAssetFullCandles(instrument);
      final price = getIt<InvestDashboardStore>().getPendingPriceBySymbol(instrumentId);
      final lastCandle = CandleModel(
        open: price.toDouble(),
        close: price.toDouble(),
        high: price.toDouble(),
        low: price.toDouble(),
        date: DateTime.now().millisecondsSinceEpoch,
      );

      return [
        ...fetchedCandles,
        lastCandle,
      ];
    }
  }

  @action
  Future<List<CandleModel>> fetchAssetFullCandles(String instrument) async {
    try {
      var candlesToReturn = <CandleModel>[];
      final investNewStore = getIt.get<InvestNewStore>();

      final to = DateTime.now().millisecondsSinceEpoch;
      final from = chartDateToHelper(investNewStore.chartInterval);

      final model = CandlesRequestModel(
        candleId: '${instrument}USD:1;USDUSDT:0',
        type: chartResolutionHelper(investNewStore.chartInterval),
        bidOrAsk: 1,
        fromDate: from,
        toDate: to,
        mergeCandlesCount: 1,
      );

      final candlesResponse = await sNetwork.getCandlesModule().getCandles(model);

      candlesResponse.pick(
        onData: (candles) {
          final candles1 = candles.candles
              .map(
                (e) => CandleModel(
                  open: e.open,
                  close: e.close,
                  high: e.high,
                  low: e.low,
                  date: e.date,
                ),
              )
              .toList();

          if (investNewStore.chartInterval == 0) {
            candlesFull1List.add(
              CandlesWithIdModel(
                instrumentId: instrument,
                candles: candles1,
              ),
            );
          } else if (investNewStore.chartInterval == 1) {
            candlesFull2List.add(
              CandlesWithIdModel(
                instrumentId: instrument,
                candles: candles1,
              ),
            );
          } else if (investNewStore.chartInterval == 2) {
            candlesFull3List.add(
              CandlesWithIdModel(
                instrumentId: instrument,
                candles: candles1,
              ),
            );
          } else if (investNewStore.chartInterval == 3) {
            candlesFull4List.add(
              CandlesWithIdModel(
                instrumentId: instrument,
                candles: candles1,
              ),
            );
          }

          candlesToReturn = candles1;
        },
        onError: (e) {},
      );

      return candlesToReturn;
    } catch (e) {
      return [];
    }
  }
}
