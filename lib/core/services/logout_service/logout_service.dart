import 'dart:async';

import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/intercom/intercom_service.dart';
import 'package:jetwallet/core/services/local_cache/local_cache_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/logout_service/logout_union.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorization_union.dart';
import 'package:jetwallet/features/auth/verification_reg/store/verification_store.dart';
import 'package:jetwallet/features/iban/store/iban_store.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_networking/modules/auth_api/models/logout/logout_request_moder.dart';

import '../session_check_service.dart';

part 'logout_service.g.dart';

class LogoutService = _LogoutServiceBase with _$LogoutService;

abstract class _LogoutServiceBase with Store {
  final _logger = getIt.get<SimpleLoggerService>();
  final _loggerValue = 'LogoutStore';

  LogoutUnion union = const LogoutUnion.result();

  @action
  Future<void> logout(
    String from, {
    required Function() callbackAfterSend,
    bool withLoading = true,
    bool resetPin = false,
  }) async {
    try {
      getIt.get<VerificationStore>().clear();

      _logger.log(
        level: Level.info,
        place: _loggerValue,
        message: 'User start logout from $from',
      );

      getIt<AppStore>().setAppStatus(AppStatus.end);

      final authStore = getIt.get<AppStore>().authState;
      if (getIt.get<AppStore>().authStatus is Unauthorized) {
        _logger.log(
          level: Level.warning,
          place: _loggerValue,
          message: 'User already is Unauthorized',
        );

        await _clearUserData();

        // Make init router unauthorized
        await pushToFirstPage();

        union = const LogoutUnion.result();

        callbackAfterSend.call();

        return;
      }

      if (resetPin) {
        _logger.log(
          level: Level.info,
          place: _loggerValue,
          message: 'Reset PIN',
        );

        final _ = await sNetwork.getAuthModule().postResetPin();
      }

      if (withLoading) {
        union = const LogoutUnion.loading();
      }

      try {
        // Disconet from SignalR
        unawaited(getIt.get<SignalRService>().killSignalR());
      } catch (e) {
        _logger.log(
          level: Level.error,
          place: _loggerValue,
          message: 'Error with signalR: $e',
        );
      }

      try {
        if (authStore.token.isNotEmpty) {
          final model = LogoutRequestModel(
            token: authStore.token,
          );

          _logger.log(
            level: Level.info,
            place: _loggerValue,
            message: 'Send logout request to server',
          );

          await sNetwork.getAuthModule().postLogout(model);
        }
      } catch (e) {
        _logger.log(
          level: Level.error,
          place: _loggerValue,
          message: 'Error with logout request: $e',
        );

        await _clearUserData();
        await pushToFirstPage();
      }

      await _clearUserData();

      // Make init router unauthorized
      await pushToFirstPage();

      sSignalRModules.clearSignalRModule();

      _logger.log(
        level: Level.debug,
        place: _loggerValue,
        message: 'Logout success',
      );

      callbackAfterSend.call();
      union = const LogoutUnion.result();
    } catch (e) {
      _logger.log(
        level: Level.error,
        place: _loggerValue,
        message: 'LOGOUT ERROR: $e',
      );

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

    if (getIt.isRegistered<AppStore>()) {
      getIt<AppStore>().resetAppStore();
    }
    if (getIt.isRegistered<IbanStore>()) {
      getIt<IbanStore>().clearData();
    }

    if (getIt.isRegistered<SessionCheckService>()) {
      getIt.get<SessionCheckService>().clearSessionData();
    }

    if (getIt.isRegistered<IntercomService>()) {
      await getIt.get<IntercomService>().logout();
    }
    //if (getIt.isRegistered<ZenDeskService>()) {
    //  await getIt.get<ZenDeskService>().logoutZenDesk();
    //}
  }

  Future<void> pushToFirstPage() async {
    await getIt<AppStore>().pushToUnlogin();
    await sRouter.replaceAll([
      const OnboardingRoute(),
    ]);
  }
}
