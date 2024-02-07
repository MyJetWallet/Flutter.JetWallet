import 'package:charts/simple_chart.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/features/invest/stores/dashboard/invest_dashboard_store.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/modules/candles_api/models/candles_request_model.dart';

import '../../../../core/di/di.dart';
import '../../../../core/services/simple_networking/simple_networking.dart';

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
        type: Timeframe.week,
        bidOrAsk: 0,
        fromDate: fromDate.millisecondsSinceEpoch,
        toDate: toDate.millisecondsSinceEpoch,
        mergeCandlesCount: 1,
      );

      final candlesResponse = await sNetwork.getCandlesModule().getCandles(model);

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
          ).toList();

          candlesList.add(CandlesWithIdModel(
            instrumentId: instrumentId,
            candles: candles1,
          ),);

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
