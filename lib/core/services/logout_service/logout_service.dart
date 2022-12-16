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

part 'logout_service.g.dart';

class LogoutService = _LogoutServiceBase with _$LogoutService;

abstract class _LogoutServiceBase with Store {
  static final _logger = Logger('LogoutStore');

  LogoutUnion union = const LogoutUnion.result();

  @action
  Future<void> logout(
    String from, {
    bool withLoading = true,
    bool resetPin = false,
  }) async {
    _logger.log(notifier, 'Logout start $from');

    final authStore = getIt.get<AppStore>().authState;

    if (getIt.get<AppStore>().authStatus is Unauthorized) {
      _logger.log(stateFlow, 'authStatus is Unauthorized');

      await sLocalStorageService.clearStorage();

      // Make init router unauthorized
      await getIt<AppStore>().pushToUnlogin();
      await sRouter.replaceAll([
        const AppInitRoute(),
      ]);

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

        _syncLogout(model);
      }
    } catch (e) {
      _logger.log(error, '_syncLogout e: ${e.toString()}');
    }

    try {
      // Clear analytics
      unawaited(sAnalytics.logout());

      // Disconet from SignalR
      await getIt.get<SignalRService>().signalR.disconnect();

      // Clear all flutter_secure_storage and shared_preferences
      await sLocalStorageService.clearStorage();
      await getIt<LocalCacheService>().clearAllCache();

      /// Clear UserInfo
      sUserInfo.clear();

      union = const LogoutUnion.result();

      // Make init router unauthorized
      await getIt<AppStore>().pushToUnlogin();
      await sRouter.replaceAll([
        const AppInitRoute(),
      ]);

      // Reset User state
      getIt<AppStore>().resetAppStore();

      sSignalRModules.clearSignalRModule();

      await getIt<AppStore>().getAuthStatus();
    } catch (e) {
      _logger.log(error, 'Logout error: $e');
    }

    _logger.log(stateFlow, 'Logout success');
  }

  @action
  void _syncLogout(LogoutRequestModel model) {
    final _ = sNetwork.getAuthModule().postLogout(model);
  }
}
