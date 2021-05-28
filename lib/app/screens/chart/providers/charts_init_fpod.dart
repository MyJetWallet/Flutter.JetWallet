import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service_providers.dart';
import '../../../../service/services/charts/model/get_candles/candles_request_model.dart';
import 'charts_notipod.dart';

final chartsInitFpod = FutureProvider.family<void, String>(
  (ref, instrumentId) async {
    final chartsNotipod = ref.watch(chartNotipod.notifier);
    final chartsService = ref.watch(chartsServicePod);

    final model = CandlesRequestModel(
      instrumentId: instrumentId,
      bidOrAsk: 0,
      fromDate: 1622032561000,
      toDate: 1622039761000,
      candleType: 0,
    );

    final candles = await chartsService.getCandles(model);

    chartsNotipod.initCandles(candles.candles);
  },
);
