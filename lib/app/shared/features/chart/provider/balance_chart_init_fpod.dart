import 'package:charts/entity/resolution_string_enum.dart';
import 'package:charts/utils/data_feed_util.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/shared/features/chart/helper/prepare_candles_from.dart';
import 'package:jetwallet/service/services/chart/model/wallet_history_request_model.dart';

import '../../../../../service/services/chart/model/candles_request_model.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../helper/format_merge_candles_count.dart';
import '../helper/format_resolution.dart';
import '../notifier/chart_notipod.dart';

final balanceChartInitFpod = FutureProvider.autoDispose<void>(
  (ref) async {
    final notifier = ref.watch(chartNotipod.notifier);
    final chartService = ref.watch(chartServicePod);

    const model = WalletHistoryRequestModel(
      //TODO(Vova): add asset id
      targetAsset: 'BTC',
      period: TimeLength.day,
    );

    final walletHistory = await chartService.walletHistory(model);

    notifier.updateCandles(candlesFrom(walletHistory.graph));
  },
);
