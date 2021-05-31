import 'package:charts/utils/data_feed_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service_providers.dart';
import '../../../../service/services/charts/model/get_candles/candles_request_model.dart';
import '../helpers/round_down_date.dart';
import 'charts_notipod.dart';

final chartsInitFpod = FutureProvider.family.autoDispose<void, String>(
  (ref, instrumentId) async {
    final chartsNotipod = ref.watch(chartNotipod.notifier);
    final chartsService = ref.watch(chartsServicePod);

    final toDate = DateTime.now().toUtc();
    final depth = DataFeedUtil.calculateHistoryDepth(
      'm',
    );
    final fromDate = toDate.subtract(depth.intervalBackDuration);

    final model = CandlesRequestModel(
      instrumentId: instrumentId,
      bidOrAsk: 0,
      fromDate: roundDown(fromDate).millisecondsSinceEpoch,
      toDate: roundDown(toDate).millisecondsSinceEpoch,
      candleType: 0,
    );

    final candles = await chartsService.getCandles(model);

    chartsNotipod.updateCandles(candles.candles);
  },
);
