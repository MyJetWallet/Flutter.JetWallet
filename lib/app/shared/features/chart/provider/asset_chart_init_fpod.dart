import 'package:charts/simple_chart.dart';
import 'package:charts/utils/data_feed_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/chart/model/candles_request_model.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../helper/format_merge_candles_count.dart';
import '../helper/format_resolution.dart';
import '../notifier/chart_notipod.dart';

final assetChartInitFpod = FutureProvider.family.autoDispose<void, String>(
  (ref, instrumentId) async {
    try {
      final notifier = ref.watch(chartNotipod.notifier);
      final chartService = ref.watch(chartServicePod);

      final toDate = DateTime.now().toUtc();

      final dayDepth = DataFeedUtil.calculateHistoryDepth(Period.day);
      final dayFromDate = toDate.subtract(dayDepth.intervalBackDuration);

      final weekDepth = DataFeedUtil.calculateHistoryDepth(Period.week);
      final weekFromDate = toDate.subtract(weekDepth.intervalBackDuration);

      final monthDepth = DataFeedUtil.calculateHistoryDepth(Period.month);
      final monthFromDate = toDate.subtract(monthDepth.intervalBackDuration);

      final yearDepth = DataFeedUtil.calculateHistoryDepth(Period.year);
      final yearFromDate = toDate.subtract(yearDepth.intervalBackDuration);

      final allDepth = DataFeedUtil.calculateHistoryDepth(Period.all);
      final allFromDate = toDate.subtract(allDepth.intervalBackDuration);

      final dayModel = CandlesRequestModel(
        candleId: instrumentId,
        type: timeFrameFrom(Period.day),
        bidOrAsk: 0,
        fromDate: dayFromDate.millisecondsSinceEpoch,
        toDate: toDate.millisecondsSinceEpoch,
        mergeCandlesCount: mergeCandlesCountFrom(Period.day),
      );

      final dayCandles = await chartService.candles(dayModel);

      final weekModel = CandlesRequestModel(
        candleId: instrumentId,
        type: timeFrameFrom(Period.week),
        bidOrAsk: 0,
        fromDate: weekFromDate.millisecondsSinceEpoch,
        toDate: toDate.millisecondsSinceEpoch,
        mergeCandlesCount: mergeCandlesCountFrom(Period.week),
      );

      final weekCandles = await chartService.candles(weekModel);

      final monthModel = CandlesRequestModel(
        candleId: instrumentId,
        type: timeFrameFrom(Period.month),
        bidOrAsk: 0,
        fromDate: monthFromDate.millisecondsSinceEpoch,
        toDate: toDate.millisecondsSinceEpoch,
        mergeCandlesCount: mergeCandlesCountFrom(Period.month),
      );

      final monthCandles = await chartService.candles(monthModel);

      final yearModel = CandlesRequestModel(
        candleId: instrumentId,
        type: timeFrameFrom(Period.year),
        bidOrAsk: 0,
        fromDate: yearFromDate.millisecondsSinceEpoch,
        toDate: toDate.millisecondsSinceEpoch,
        mergeCandlesCount: mergeCandlesCountFrom(Period.year),
      );

      final yearCandles = await chartService.candles(yearModel);

      final allModel = CandlesRequestModel(
        candleId: instrumentId,
        type: timeFrameFrom(Period.all),
        bidOrAsk: 0,
        fromDate: allFromDate.millisecondsSinceEpoch,
        toDate: toDate.millisecondsSinceEpoch,
        mergeCandlesCount: mergeCandlesCountFrom(Period.all),
      );

      final allCandles = await chartService.candles(allModel);

      final mapCandles = {
        Period.day: dayCandles.candles,
        Period.week: weekCandles.candles,
        Period.month: monthCandles.candles,
        Period.year: yearCandles.candles,
        Period.all: allCandles.candles,
      };

      notifier.updateCandles(mapCandles);
    } catch (_) {
      sShowErrorNotification(
        ref.read(sNotificationQueueNotipod.notifier),
        'Something went wrong',
      );
    }
  },
);
