import 'dart:async';

import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/local_cache/local_cache_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logout_service/logout_union.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/app_builder.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorization_union.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/auth_api/models/logout/logout_request_moder.dart';
import 'package:simple_networking/modules/logs_api/models/add_log_model.dart';
import 'package:logger/logger.dart' as logPrint;

part 'logout_service.g.dart';

class LogoutService = _LogoutServiceBase with _$LogoutService;

abstract class _LogoutServiceBase with Store {
  static final _logger = Logger('LogoutStore');
  final log = logPrint.Logger();

  LogoutUnion union = const LogoutUnion.result();

  @action
  Future<void> logout(
    String from, {
    bool withLoading = true,
    bool resetPin = false,
  }) async {
    try {
      _logger.log(notifier, 'Logout start $from');

      getIt<AppStore>().setAppStatus(AppStatus.End);

      final authStore = getIt.get<AppStore>().authState;
      if (getIt.get<AppStore>().authStatus is Unauthorized) {
        _logger.log(stateFlow, 'authStatus is Unauthorized');

        await _clearUserData();

        // Make init router unauthorized
        await pushToFirstPage();

        union = const LogoutUnion.result();

        return;
      }

      if (resetPin) {
        _logger.log(stateFlow, 'resetPin');

        final _ = await sNetwork.getAuthModule().postResetPin();
      }

      if (withLoading) {
        union = const LogoutUnion.loading();
      }

      try {
        if (authStore.token.isNotEmpty) {
          final model = LogoutRequestModel(
            token: authStore.token,
          );

          _logger.log(stateFlow, '_syncLogout');

          await sNetwork.getAuthModule().postLogout(model);
        }
      } catch (e) {
        _logger.log(errorLog, '_syncLogout e: ${e.toString()}');

        await _clearUserData();
        await pushToFirstPage();
      }

      // Clear analytics
      unawaited(sAnalytics.logout());

      // Disconet from SignalR
      if (getIt.get<SignalRService>().signalR != null) {
        await getIt.get<SignalRService>().signalR!.disconnect();
      }

      await _clearUserData();

      // Make init router unauthorized
      await pushToFirstPage();

      sSignalRModules.clearSignalRModule();

      await getIt<AppStore>().getAuthStatus();

      _logger.log(stateFlow, 'Logout success');

      union = const LogoutUnion.result();
    } catch (e) {
      log.e('LOGOUT ERROR: $e');
      _logger.log(errorLog, 'LOGOUT ERROR: $e');

      await _clearUserData();
      await pushToFirstPage();

      union = const LogoutUnion.result();
    }
  }

  Future<void> _clearUserData() async {
    /// Clear UserInfo
    if (getIt.isRegistered<UserInfoService>()) {
      getIt.get<UserInfoService>().clear();
    }

    // Clear all flutter_secure_storage and shared_preferences
    await sLocalStorageService.clearStorage();
    await getIt<LocalCacheService>().clearAllCache();
    getIt<AppStore>().resetAppStore();
  }

  Future<void> pushToFirstPage() async {
    await getIt<AppStore>().pushToUnlogin();
    await sRouter.replaceAll([
      const AppInitRoute(),
    ]);
  }
}
