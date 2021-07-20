import 'package:charts/utils/data_feed_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/chart/model/candles_request_model.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../helper/round_down_date.dart';
import '../notifier/chart_notipod.dart';

final chartInitFpod = FutureProvider.family.autoDispose<void, String>(
  (ref, instrumentId) async {
    final notifier = ref.watch(chartNotipod.notifier);
    final chartService = ref.watch(chartServicePod);

    final toDate = DateTime.now().toUtc();
    final depth = DataFeedUtil.calculateHistoryDepth('m');
    final fromDate = toDate.subtract(depth.intervalBackDuration);

    final model = CandlesRequestModel(
      instrumentId: instrumentId,
      bidOrAsk: 0,
      fromDate: roundDown(fromDate).millisecondsSinceEpoch,
      toDate: roundDown(toDate).millisecondsSinceEpoch,
      candleType: 0,
    );

    final candles = await chartService.candles(model);

    notifier.updateCandles(candles.candles);
  },
);
