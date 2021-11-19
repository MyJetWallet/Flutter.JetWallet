import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../shared/logging/levels.dart';
import '../../../shared/services/remote_config_service/service/remote_config_service.dart';
import 'remote_config_union.dart';

const _retryTime = 10; // in seconds
const _splashScreenDuration = 3000; // in milliseconds

class RemoteConfigNotifier extends StateNotifier<RemoteConfigUnion> {
  RemoteConfigNotifier() : super(const Loading()) {
    _fetchAndActivate();
  }

  static final _logger = Logger('RemoteConfigNotifier');

  Timer? _timer;
  late Timer _durationTimer;
  late int retryTime;

  Future<void> _fetchAndActivate() async {
    state = const Loading();

    try {
      final stopwatch = Stopwatch()..start();

      await RemoteConfigService().fetchAndActivate();

      stopwatch.stop();

      if (stopwatch.elapsedMilliseconds < _splashScreenDuration) {
        _durationTimer = Timer(
          Duration(
            milliseconds: _splashScreenDuration - stopwatch.elapsedMilliseconds,
          ),
          () {
            state = const Success();
          },
        );
      } else {
        state = const Success();
      }
    } catch (e) {
      _logger.log(stateFlow, '_fetchAndActivate', e);

      state = const Loading();

      _refreshTimer();
    }
  }

  void _refreshTimer() {
    _timer?.cancel();
    retryTime = _retryTime;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (retryTime == 0) {
          timer.cancel();
          _fetchAndActivate();
        } else {
          retryTime -= 1;
        }
      },
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _durationTimer.cancel();
    super.dispose();
  }
}
