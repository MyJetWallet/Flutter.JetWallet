import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';

import 'time_tracking_state.dart';

class TimeTrackingNotifier extends StateNotifier<TimeTrackingState> {
  TimeTrackingNotifier() : super(const TimeTrackingState()) {
    updateStartApp();
  }

  void updateStartApp() {
    state = state.copyWith(startApp: DateTime.now());
  }

  void updateMarketOpened() {
    if (!mounted) return;
    if (state.startApp != null && !state.timeStartMarketSent) {
      _updateMarketOpened();
      final startMs = state.startApp!.millisecondsSinceEpoch;
      final marketMs = DateTime.now().millisecondsSinceEpoch;
      final timeToMarket = marketMs - startMs;
      sAnalytics.timeStartMarket(time: '$timeToMarket ms');
      state = state.copyWith(
        timeStartMarketSent: true,
      );
    }
  }

  void _updateMarketOpened() {
    state = state.copyWith(marketOpened: DateTime.now());
  }

  void updateSignalRStarted(DateTime? value) {
    state = state.copyWith(signalRStarted: value);
  }

  void updateInitFinishedFirstCheck(DateTime? value) {
    if (!mounted) return;
    if (state.signalRStarted != null && !state.timeSignalRCheckIFSent) {
      final startMs = state.signalRStarted!.millisecondsSinceEpoch;
      final initFinishedMs = value!.millisecondsSinceEpoch;
      final timeToIFFirstCheck = initFinishedMs - startMs;
      sAnalytics.timeSignalRCheckIF(time: '$timeToIFFirstCheck ms');
      state = state.copyWith(
        timeSignalRCheckIFSent: true,
        initFinishedFirstCheck: value,
      );
    }
  }

  void updateInitFinishedReceived(DateTime? value) {
    if (!mounted) return;
    if (state.startApp != null && !state.timeStartInitFinishedSent) {
      final startMs = state.startApp!.millisecondsSinceEpoch;
      final initFinishedMs = value!.millisecondsSinceEpoch;
      final timeToIF = initFinishedMs - startMs;
      sAnalytics.timeStartInitFinished(time: '$timeToIF ms');
      state = state.copyWith(
        timeStartInitFinishedSent: true,
        initFinishedReceived: value,
      );
    }
    if (state.signalRStarted != null && !state.timeSignalRReceiveIFSent) {
      final startMs = state.signalRStarted!.millisecondsSinceEpoch;
      final initFinishedMs = value!.millisecondsSinceEpoch;
      final timeToIFFirstCheck = initFinishedMs - startMs;
      sAnalytics.timeSignalRReceiveIF(time: '$timeToIFFirstCheck ms');
      state = state.copyWith(
        timeSignalRReceiveIFSent: true,
      );
    }
  }

  void updateConfigReceived(DateTime? value) {
    if (!mounted) return;
    if (state.startApp != null && !state.timeStartConfigSent) {
      final startMs = state.startApp!.millisecondsSinceEpoch;
      final configMs = value!.millisecondsSinceEpoch;
      final timeToConfig= configMs - startMs;
      sAnalytics.timeStartConfig(time: '$timeToConfig ms');
      state = state.copyWith(
        timeStartConfigSent: true,
        configReceived: value,
      );
    }
  }

  void isFinishedOnMarketCheck() {
    if (!mounted) return;
    if (!state.initFinishedOnMarketSent) {
      sAnalytics.initFinishedOnMarket(
        isFinished: '${state.timeStartInitFinishedSent}',
      );
      state = state.copyWith(
        initFinishedOnMarketSent: true,
      );
    }
  }

  void clear() {
    state = state.copyWith(
      startApp: null,
      marketOpened: null,
      signalRStarted: null,
      initFinishedFirstCheck: null,
      initFinishedReceived: null,
      configReceived: null,
    );
  }
}
