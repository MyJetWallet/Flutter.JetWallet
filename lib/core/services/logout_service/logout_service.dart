import 'dart:async';

import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logout_service/logout_union.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
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
  Future<void> logout({bool withLoading = true, bool resetPin = false}) async {
    _logger.log(notifier, 'logout');

    final authStore = getIt.get<AppStore>().authState;

    if (resetPin) {
      final _ = await sNetwork.getAuthModule().postResetPin();
    }

    try {
      if (withLoading) {
        union = const LogoutUnion.loading();
      }

      final model = LogoutRequestModel(
        token: authStore.token,
      );

      _syncLogout(model);
    } catch (e) {
      _logger.log(stateFlow, 'logout', e);
    } finally {
      await sLocalStorageService.clearStorage();
      await sLocalStorageService
          .clearStorageForCrypto(sSignalRModules.getCurrencies);

      sSignalRModules.clearSignalRModule();

      /// Disconet from SignalR
      await getIt.get<SignalRService>().signalR.disconnect();

      /// Set Unauthorized status
      getIt.get<AppStore>().setAuthStatus(const Unauthorized());

      /// Clear some user variables
      sUserInfo.clear();
      getIt.get<AppStore>().resetResendButton();

      unawaited(sAnalytics.logout());

      union = const LogoutUnion.result();

      unawaited(
        sRouter.navigate(
          const HomeRouter(
            children: [
              EarnRouter(),
            ],
          ),
        ),
      );
    }
  }

  @action
  void _syncLogout(LogoutRequestModel model) {
    final _ = sNetwork.getAuthModule().postLogout(model);
  }
}
