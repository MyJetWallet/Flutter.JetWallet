import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_networking/shared/api_urls.dart';

import '../../../shared/logging/levels.dart';
import '../../../shared/providers/flavor_pod.dart';
//import '../../../shared/services/remote_config_service/service/remote_config_service.dart';
import 'remote_config_union.dart';

const _retryTime = 10; // in seconds
//const _splashScreenDuration = 3000; // in milliseconds

class RemoteConfigNotifier extends StateNotifier<RemoteConfigUnion> {
  RemoteConfigNotifier(this.read) : super(const Loading()) {
    _fetchAndActivate();
  }

  static final _logger = Logger('RemoteConfigNotifier');
  Reader read;

  Timer? _timer;
  late Timer _durationTimer;
  late int retryTime;
  final stopwatch = Stopwatch();
  bool isStopwatchStarted = false;

  /*
  void _startStopwatch() {
    isStopwatchStarted = true;

    if (!isStopwatchStarted) {
      stopwatch.start();
    }
  }
  */

  Future<void> _fetchAndActivate() async {
    state = const Loading();

    try {
      //_startStopwatch();

      //await RemoteConfigService().fetchAndActivate();

      //stopwatch.stop();

      final flavor = read(flavorPod);

      if (flavor == Flavor.prod) {
        candlesApi = 'https://candles-api.simple.app/api/v3';
        authApi = 'https://wallet-api.simple.app/auth/v1';
        walletApi = 'https://wallet-api.simple.app/api/v1';
        walletApiSignalR = 'https://wallet-api.simple.app/signalr';
        validationApi = 'https://validation-api.simple.app/api/v1';
        iconApi = 'https://wallet-api.simple.app/icons';
      } else {
        candlesApi = 'https://candles-api-uat.simple-spot.biz/api/v3';
        authApi = 'https://wallet-api-uat.simple-spot.biz/auth/v1';
        walletApi = 'https://wallet-api-uat.simple-spot.biz/api/v1';
        walletApiSignalR = 'https://wallet-api-uat.simple-spot.biz/signalr';
        validationApi = 'https://validation-api-uat.simple-spot.biz/api/v1';
        iconApi = 'https://wallet-api.simple-spot.biz/icons';
      }

      state = const Success();

      /*
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
      */
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
