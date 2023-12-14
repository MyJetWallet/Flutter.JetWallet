import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/models/remote_config_union.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorized_union.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:simple_analytics/simple_analytics.dart';

class TimerService extends ChangeNotifier {
  Timer? _timer;

  Duration get currentDuration => _currentDuration;
  final Duration _currentDuration = Duration.zero;

  bool get isRunning => _timer != null;

  void _finish(Timer timer) {
    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home) {
      sAnalytics.pinAfterWaiting(timeAfterBlock: 300);

      getIt.get<AppStore>().setHomeTab(0);

      getIt<AppRouter>().replaceAll([
        PinScreenRoute(
          union: const Verification(),
          cannotLeave: true,
          displayHeader: false,
          onVerificationEnd: () {
            sRouter.replaceAll([
              const HomeRouter(
                children: [
                  MyWalletsRouter(),
                ],
              ),
            ]);
          },
        ),
      ]);
    }
    stop();
    notifyListeners();
  }

  void start() {
    if (_timer != null) return;

    _timer = Timer.periodic(const Duration(minutes: 5), _finish);
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void reset() {
    stop();
    start();
  }

  static TimerService of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<TimerServiceProvider>();

    return provider!._service;
  }
}

class TimerServiceProvider extends InheritedWidget {
  const TimerServiceProvider({
    super.key,
    required TimerService service,
    required super.child,
  }) : _service = service;
  final TimerService _service;

  @override
  bool updateShouldNotify(TimerServiceProvider old) => _service != old._service;
}

class SimpleActivityDetector extends StatefulWidget {
  const SimpleActivityDetector({
    super.key,
    this.child,
    required this.onShoulNavigate,
  });

  final Function(BuildContext) onShoulNavigate;
  final Widget? child;

  @override
  State<SimpleActivityDetector> createState() => _SimpleActivityDetectorState();
}

class _SimpleActivityDetectorState extends State<SimpleActivityDetector> {
  TimerService? _timerService;

  @override
  Widget build(BuildContext context) {
    if (_timerService == null) {
      _timerService = TimerService.of(context);
      _timerService!.start();
      _timerService!.addListener(_handleTimerNotifier);
    }

    return GestureDetector(
      onTap: _hangeUserInteraction,
      onPanDown: _hangeUserInteraction,
      onScaleStart: _hangeUserInteraction,
      child: widget.child,
    );
  }

  void _hangeUserInteraction([_]) {
    _timerService!.reset();
  }

  void _handleTimerNotifier() {}
}
