import 'dart:async';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/force_update_service.dart';
import 'package:jetwallet/core/services/internet_checker_service.dart';
import 'package:jetwallet/core/services/kyc_profile_countries.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/push_notification.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorization_union.dart';
import 'package:jetwallet/features/app/store/models/authorized_union.dart';
import 'package:jetwallet/features/kyc/kyc_service.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:simple_networking/modules/auth_api/models/session_chek/session_check_response_model.dart';

@lazySingleton
class StartupService {
  static final _logger = Logger('StartupService');

  bool initSignaWasCall = false;
  bool isServicesRegistred = false;
  bool isAlreadyInited = false;

  Future<void> _initSignalRSynchronously() async {
    await getIt.get<SignalRService>().start();
  }

  void authenticatedBoot() {
    _logger.log(notifier, 'authenticatedBoot');

    processStartupState();
  }

  void successfullAuthentication() {
    _logger.log(stateFlow, 'successfullAuthentication');

    initSignaWasCall = false;

    TextInput.finishAutofillContext(); // prompt to save credentials00

    getIt.get<AppStore>().setFromLoginRegister(true);

    processStartupState().then((value) {
      /// Needed to dissmis Register/Login pushed screens
      getIt.get<AppStore>().checkInitRouter();

      sRouter.replaceAll([const AppInitRoute()]);
    });
  }

  Future<void> processStartupState() async {
    _logger.log(notifier, 'Process Startup State');

    if (getIt.get<AppStore>().authStatus is Authorized) {
      try {
        await getIt.get<SNetwork>().recreateDio();

        unawaited(getIt.get<PushNotification>().registerToken());

        final infoRequest = await sNetwork.getAuthModule().postSessionCheck();
        infoRequest.pick(
          onData: (SessionCheckResponseModel info) async {
            if (!initSignaWasCall) {
              await _initSignalRSynchronously();
              initSignaWasCall = true;
            }

            if (!isServicesRegistred) {
              await startingServices();
            } else {
              await reCreateServices();
            }

            if (info.toCheckSimpleKyc) {
              getIt.get<AppStore>().setAuthorizedStatus(
                    const UserDataVerification(),
                  );
            } else if (info.toSetupPin) {
              getIt.get<AppStore>().setAuthorizedStatus(
                    const PinSetup(),
                  );
            } else {
              getIt.get<AppStore>().setAuthorizedStatus(
                    const PinVerification(),
                  );
            }

            unawaited(getIt.get<AppStore>().checkInitRouter());
          },
          onError: (error) {
            _logger.log(stateFlow, 'Failed to fetch session info', error);

            getIt.get<LogoutService>().logout();
          },
        );
      } catch (e) {
        _logger.log(stateFlow, 'Failed to fetch session info', e);

        await getIt.get<LogoutService>().logout();

        // TODO (discuss this flow)
        // In this case app will keep loading and nothing will happen
        // In order to retry user will need to reboot application
        _logger.log(stateFlow, 'Failed to fetch session info', e);
      }
    }
  }

  Future<void> startingServices() async {
    try {
      getIt.registerSingleton<KycService>(
        KycService(),
      );

      getIt.registerSingletonAsync<InternetCheckerService>(
        () async => InternetCheckerService().initialise(),
      );

      getIt.registerSingletonAsync<KycProfileCountries>(
        () async => KycProfileCountries().init(),
      );

      getIt.registerSingletonAsync<ProfileGetUserCountry>(
        () async => ProfileGetUserCountry().init(),
      );

      getIt.registerSingletonAsync<ForceServiceUpdate>(
        () async => ForceServiceUpdate().init(),
      );

      await getIt.isReady<KycProfileCountries>();
      await getIt.isReady<ProfileGetUserCountry>();

      isServicesRegistred = true;

      return;
    } catch (e) {
      _logger.log(stateFlow, 'Failed startingServices', e);
      print(e);
    }
  }

  Future<void> reCreateServices() async {
    try {
      if (getIt.isRegistered<KycService>()) {
        getIt<KycService>().init();
      }

      if (getIt.isRegistered<KycProfileCountries>()) {
        await getIt<KycProfileCountries>().init();
      }

      if (getIt.isRegistered<ProfileGetUserCountry>()) {
        await getIt<ProfileGetUserCountry>().init();
      }
    } catch (e) {}
  }

  /// Called when user makes cold boot and has enabled 2FA
  /// and it was verified successfully
  void twoFaVerified() {
    _logger.log(notifier, 'twoFaVerified');

    _processPinState();
  }

  void pinSet() {
    _logger.log(notifier, 'pinSet');

    getIt.get<AppStore>().setAuthorizedStatus(
          const AskBioUsing(),
        );
  }

  void pinVerified() {
    _logger.log(notifier, 'pinVerified');

    getIt.get<AppStore>().setAuthorizedStatus(
          const Home(),
        );

    getIt.get<AppStore>().checkInitRouter();
  }

  void _processPinState() {
    try {
      final userInfo = getIt.get<UserInfoService>().userInfo;

      if (userInfo.pinEnabled) {
        getIt.get<AppStore>().setAuthorizedStatus(
              const PinVerification(),
            );

        sRouter.push(
          PinScreenRoute(
            union: const PinFlowUnion.verification(),
            cannotLeave: true,
            displayHeader: false,
          ),
        );
      } else {
        if (getIt.get<AppStore>().fromLoginRegister || !userInfo.pinDisabled) {
          getIt.get<AppStore>().setAuthorizedStatus(
                const PinSetup(),
              );

          sRouter.push(
            PinScreenRoute(
              union: const PinFlowUnion.setup(),
              cannotLeave: true,
            ),
          );
        } else {
          getIt.get<AppStore>().setAuthorizedStatus(
                const PinSetup(),
              );

          sRouter.push(
            PinScreenRoute(
              union: const PinFlowUnion.setup(),
              cannotLeave: true,
            ),
          );
        }
      }
    } catch (e) {
      getIt.get<LogoutService>().logout();
    }
  }
}
