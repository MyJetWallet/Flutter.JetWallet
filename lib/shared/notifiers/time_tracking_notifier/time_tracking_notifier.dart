import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';

import '../../providers/service_providers.dart';
import '../../services/local_storage_service.dart';
import 'time_tracking_state.dart';

class TimeTrackingNotifier extends StateNotifier<TimeTrackingState> {
  TimeTrackingNotifier(
      {
        required this.read,
      }) : super(const TimeTrackingState());

  final Reader read;

  Future<void> updateAppStarted(DateTime value) async {
    final storage = read(localStorageServicePod);
    await storage.setString(
      startApp,
      '${value.millisecondsSinceEpoch}',
    );
    state = state.copyWith(signalRStarted: value);
  }

  Future<void> updateMarketOpened() async {
    final storage = read(localStorageServicePod);
    final startAppSaved = await storage.getValue(startApp);
    final wasSent = await storage.getValue(timeStartMarketSent);
    if (!mounted) return;
    if (startAppSaved != null && wasSent == null) {
      final startMs = int.parse(startAppSaved);
      final marketMs = DateTime.now().millisecondsSinceEpoch;
      final timeToMarket = marketMs - startMs;
      await storage.setString(timeStartMarketSent, 'true');
      await storage.setString(
        marketOpened,
        '${DateTime.now().millisecondsSinceEpoch}',
      );
      sAnalytics.timeStartMarket(time: '$timeToMarket ms');
      state = state.copyWith(
        timeStartMarketSent: true,
      );
    }
  }

  Future<void> updateSignalRStarted(DateTime value) async {
    final storage = read(localStorageServicePod);
    await storage.setString(
      signalRStarted,
      '${value.millisecondsSinceEpoch}',
    );
    state = state.copyWith(signalRStarted: value);
  }

  Future<void> updateInitFinishedFirstCheck(DateTime? value) async {
    final storage = read(localStorageServicePod);
    final signalRStartedSaved = await storage.getValue(signalRStarted);
    final wasSent = await storage.getValue(timeSignalRCheckIFSent);
    if (!mounted) return;
    if (signalRStartedSaved != null && wasSent == null) {
      final startMs = int.parse(signalRStartedSaved);
      final initFinishedMs = value!.millisecondsSinceEpoch;
      final timeToIFFirstCheck = initFinishedMs - startMs;
      await storage.setString(timeSignalRCheckIFSent, 'true');
      await storage.setString(initFinishedFirstCheck, '$initFinishedMs');
      sAnalytics.timeSignalRCheckIF(time: '$timeToIFFirstCheck ms');
      state = state.copyWith(
        timeSignalRCheckIFSent: true,
        initFinishedFirstCheck: value,
      );
    }
  }

  Future<void> updateInitFinishedReceived(DateTime? value) async {
    final storage = read(localStorageServicePod);
    final startAppSaved = await storage.getValue(startApp);
    final signalRStartedSaved = await storage.getValue(signalRStarted);
    final wasSent = await storage.getValue(timeStartInitFinishedSent);
    final wasSentSR = await storage.getValue(timeSignalRReceiveIFSent);
    if (!mounted) return;
    if (startAppSaved != null && wasSent == null) {
      final startMs = int.parse(startAppSaved);
      final initFinishedMs = value!.millisecondsSinceEpoch;
      final timeToIF = initFinishedMs - startMs;
      await storage.setString(timeStartInitFinishedSent, 'true');
      await storage.setString(initFinishedReceived, '$initFinishedMs');
      sAnalytics.timeStartInitFinished(time: '$timeToIF ms');
      state = state.copyWith(
        timeStartInitFinishedSent: true,
        initFinishedReceived: value,
      );
    }
    if (signalRStartedSaved != null && wasSentSR == null) {
      final startMs = int.parse(signalRStartedSaved);
      final initFinishedMs = value!.millisecondsSinceEpoch;
      final timeToIFFirstCheck = initFinishedMs - startMs;
      await storage.setString(timeSignalRReceiveIFSent, 'true');
      sAnalytics.timeSignalRReceiveIF(time: '$timeToIFFirstCheck ms');
      state = state.copyWith(
        timeSignalRReceiveIFSent: true,
      );
    }
  }

  Future<void> updateConfigReceived(DateTime? value) async {
    final storage = read(localStorageServicePod);
    final startAppSaved = await storage.getValue(startApp);
    final wasSent = await storage.getValue(timeStartConfigSent);
    if (!mounted) return;
    if (startAppSaved != null && wasSent == null) {
      final startMs = int.parse(startAppSaved);
      final configMs = value!.millisecondsSinceEpoch;
      final timeToConfig = configMs - startMs;
      await storage.setString(timeStartConfigSent, 'true');
      await storage.setString(configReceived, '$configMs');
      sAnalytics.timeStartConfig(time: '$timeToConfig ms');
      state = state.copyWith(
        timeStartConfigSent: true,
        configReceived: value,
      );
    }
  }

  Future <void> isFinishedOnMarketCheck() async {
    final storage = read(localStorageServicePod);
    final timeStartIF = await storage.getValue(timeStartInitFinishedSent);
    final wasSent = await storage.getValue(initFinishedOnMarketSent);
    if (!mounted) return;
    if (wasSent == null) {
      await storage.setString(initFinishedOnMarketSent, 'true');
      sAnalytics.initFinishedOnMarket(
        isFinished: '${timeStartIF != null}',
      );
      state = state.copyWith(
        initFinishedOnMarketSent: true,
      );
    }
  }

  Future<void> clear() async {
    final storage = read(localStorageServicePod);
    await storage.clearTimeTracker();
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
