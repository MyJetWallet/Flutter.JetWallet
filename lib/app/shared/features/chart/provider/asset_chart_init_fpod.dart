import 'package:charts/entity/resolution_string_enum.dart';
import 'package:charts/utils/data_feed_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/chart/model/candles_request_model.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../helper/format_merge_candles_count.dart';
import '../helper/format_resolution.dart';
import '../notifier/chart_notipod.dart';

final assetChartInitFpod = FutureProvider.family.autoDispose<void, String>(
  (ref, instrumentId) async {
    final notifier = ref.watch(chartNotipod.notifier);
    final chartService = ref.watch(chartServicePod);

    final toDate = DateTime.now().toUtc();
    final depth = DataFeedUtil.calculateHistoryDepth(Period.day);
    final fromDate = toDate.subtract(depth.intervalBackDuration);

    final model = CandlesRequestModel(
      candleId: instrumentId,
      type: timeFrameFrom(Period.day),
      bidOrAsk: 0,
      fromDate: fromDate.millisecondsSinceEpoch,
      toDate: toDate.millisecondsSinceEpoch,
      mergeCandlesCount: mergeCandlesCountFrom(Period.day),
    );

    final candles = await chartService.candles(model);

    notifier.updateCandles(candles.candles);
  },
);
