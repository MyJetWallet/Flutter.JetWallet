import 'dart:async';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/kyc_profile_countries.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/app/store/models/authorization_union.dart';
import 'package:jetwallet/features/app/store/models/authorized_union.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:simple_networking/modules/auth_api/models/session_chek/session_check_response_model.dart';

@lazySingleton
class StartupService {
  static final _logger = Logger('StartupService');

  bool initSignaWasCall = false;

  void _initSignalRSynchronously() {
    getIt.get<SignalRService>().start();
  }

  void authenticatedBoot() {
    _logger.log(notifier, 'authenticatedBoot');

    processStartupState();
  }

  void successfullAuthentication() {
    TextInput.finishAutofillContext(); // prompt to save credentials00

    getIt.get<AppStore>().setFromLoginRegister(true);

    processStartupState().then((value) {
      /// Needed to dissmis Register/Login pushed screens
      getIt.get<AppRouter>().push(const HomeRouter());
    });
  }

  Future<void> processStartupState() async {
    _logger.log(
      notifier,
      'PROCESS STARTUP ${getIt.get<AppStore>().authStatus}',
    );

    if (getIt.get<AppStore>().authStatus is Authorized) {
      try {
        await startingServices();

        final infoRequest = await sNetwork.getAuthModule().postSessionCheck();

        infoRequest.pick(
          onData: (SessionCheckResponseModel info) async {
            if (!initSignaWasCall) {
              _initSignalRSynchronously();
              initSignaWasCall = true;
            }

            if (info.toCheckSimpleKyc) {
              getIt.get<AppStore>().setAuthorizedStatus(
                    const UserDataVerification(),
                  );
            } else if (info.toSetupPin) {
              getIt.get<AppStore>().setAuthorizedStatus(
                    const PinSetup(),
                  );
            } else if (info.toCheckPin) {
              getIt.get<AppStore>().setAuthorizedStatus(
                    const PinVerification(),
                  );
            } else {
              getIt.get<AppStore>().setAuthorizedStatus(
                    const PinVerification(),
                  );
            }
          },
          onError: (error) {
            print('1');
            print(error.toString());
          },
        );
      } catch (e) {
        print('2');
        print(e.toString());

        // TODO (discuss this flow)
        // In this case app will keep loading and nothing will happen
        // In order to retry user will need to reboot application
        _logger.log(stateFlow, 'Failed to fetch session info', e);
      }
    }
  }

  Future<void> startingServices() async {
    getIt.registerSingletonAsync<KycProfileCountries>(
      () async => KycProfileCountries().init(),
    );

    getIt.registerSingletonAsync<ProfileGetUserCountry>(
      () async => ProfileGetUserCountry().init(),
    );

    await getIt.isReady<KycProfileCountries>();
    await getIt.isReady<ProfileGetUserCountry>();

    return;
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

    sRouter.push(
      const BiometricRouter(),
    );
  }

  void pinVerified() {
    _logger.log(notifier, 'pinVerified');

    getIt.get<AppStore>().setAuthorizedStatus(
          const Home(),
        );

    sRouter.push(
      const HomeRouter(),
    );
  }

  void _processPinState() {
    final userInfo = getIt.get<UserInfoService>().userInfo;

    print('PIN SETUP: ${userInfo.pinEnabled}');

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
  }
}
