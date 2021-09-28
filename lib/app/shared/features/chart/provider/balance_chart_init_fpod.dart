import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/shared/providers/base_currency_pod/base_currency_pod.dart';

import '../../../../../service/services/chart/model/wallet_history_request_model.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../helper/prepare_candles_from.dart';
import '../notifier/chart_notipod.dart';

final balanceChartInitFpod = FutureProvider.autoDispose<void>(
  (ref) async {
    final notifier = ref.watch(chartNotipod.notifier);
    final chartService = ref.watch(chartServicePod);
    final baseCurrency = ref.watch(baseCurrencyPod);

    final model = WalletHistoryRequestModel(
      targetAsset: baseCurrency.symbol,
      period: TimeLength.day,
    );

    final walletHistory = await chartService.walletHistory(model);

    notifier.updateCandles(candlesFrom(walletHistory.graph));
  },
);
