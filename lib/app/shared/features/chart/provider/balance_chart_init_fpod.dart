import 'package:charts/model/resolution_string_enum.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/chart/model/wallet_history_request_model.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../providers/base_currency_pod/base_currency_pod.dart';
import '../helper/prepare_candles_from.dart';
import '../notifier/chart_notipod.dart';

final balanceChartInitFpod = FutureProvider.autoDispose<void>(
  (ref) async {
    try {
      final notifier = ref.watch(chartNotipod.notifier);
      final chartService = ref.watch(chartServicePod);
      final baseCurrency = ref.watch(baseCurrencyPod);

      final dayModel = WalletHistoryRequestModel(
        targetAsset: baseCurrency.symbol,
        period: TimeLength.day,
      );

      final weekModel = WalletHistoryRequestModel(
        targetAsset: baseCurrency.symbol,
        period: TimeLength.week,
      );

      final monthModel = WalletHistoryRequestModel(
        targetAsset: baseCurrency.symbol,
        period: TimeLength.month,
      );

      final yearModel = WalletHistoryRequestModel(
        targetAsset: baseCurrency.symbol,
        period: TimeLength.year,
      );

      final allModel = WalletHistoryRequestModel(
        targetAsset: baseCurrency.symbol,
        period: TimeLength.all,
      );

      final dayWalletHistory = await chartService.walletHistory(dayModel);
      final weekWalletHistory = await chartService.walletHistory(weekModel);
      final monthWalletHistory = await chartService.walletHistory(monthModel);
      final yearWalletHistory = await chartService.walletHistory(yearModel);
      final allWalletHistory = await chartService.walletHistory(allModel);

      final mapCandles = {
        Period.day: candlesFrom(dayWalletHistory.graph),
        Period.week: candlesFrom(weekWalletHistory.graph),
        Period.month: candlesFrom(monthWalletHistory.graph),
        Period.year: candlesFrom(yearWalletHistory.graph),
        Period.all: candlesFrom(allWalletHistory.graph),
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
