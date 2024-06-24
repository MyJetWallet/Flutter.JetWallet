import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/models/remote_config_union.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorized_union.dart';
import 'package:jetwallet/features/home/store/bottom_bar_store.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../core/services/route_query_service.dart';

@lazySingleton
class TimerService extends ChangeNotifier {
  Timer? _timer;
  bool _isPinScreenOpen = false;

  Duration get currentDuration => _currentDuration;
  final Duration _currentDuration = Duration.zero;

  bool get isPinScreenOpen => _isPinScreenOpen;

  void _finish(Timer timer) {
    if (getIt.isRegistered<AppStore>() &&
        getIt.get<AppStore>().remoteConfigStatus is Success &&
        getIt.get<AppStore>().authorizedStatus is Home) {
      sAnalytics.pinAfterWaiting(timeAfterBlock: 300);
      _isPinScreenOpen = true;
      getIt.get<BottomBarStore>().setHomeTab(BottomItemType.wallets);

      getIt<AppRouter>().replaceAll([
        PinScreenRoute(
          union: const Verification(),
          cannotLeave: true,
          displayHeader: false,
          onVerificationEnd: () {
            _isPinScreenOpen = false;
            sRouter.replaceAll([
              const HomeRouter(
                children: [
                  MyWalletsRouter(),
                ],
              ),
            ]);
            Future.delayed(
              const Duration(milliseconds: 150),
              () {
                if (!getIt<RouteQueryService>().isNavigate) {
                  getIt<RouteQueryService>().runQuery();
                }
              },
            );
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
  final TimerService _timerService = getIt<TimerService>();

  @override
  void initState() {
    super.initState();
    _timerService.start();
    _timerService.addListener(_handleTimerNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _hangeUserInteraction,
      onPanDown: _hangeUserInteraction,
      onScaleStart: _hangeUserInteraction,
      child: widget.child,
    );
  }

  void _hangeUserInteraction([_]) {
    _timerService.reset();
  }

  void _handleTimerNotifier() {}
}
