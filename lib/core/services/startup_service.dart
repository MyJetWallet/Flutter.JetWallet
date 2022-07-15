import 'dart:async';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/apps_flyer_service.dart';
import 'package:jetwallet/core/services/authentication/authentication_service.dart';
import 'package:jetwallet/core/services/authentication/models/authorization_union.dart';
import 'package:jetwallet/core/services/authentication/models/authorized_union.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/networking/simple_networking.dart';
import 'package:jetwallet/core/services/refresh_token_service.dart';
import 'package:jetwallet/core/services/remote_config/models/app_config_model.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/helpers/firebase_analytics.dart';
import 'package:jetwallet/utils/loggind.dart';
import 'package:logging/logging.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/helpers/models/refresh_token_status.dart';

@lazySingleton
class StartupService {
  static final _logger = Logger('StartupService');

  void _initSignalRSynchronously() {
    //read(signalRServicePod).init();
  }

  void successfullAuthentication() {
    TextInput.finishAutofillContext(); // prompt to save credentials00

    processStartupState(fromLoginRegister: true).then((value) {
      /// Needed to dissmis Register/Login pushed screens
      getIt.get<AppRouter>().push(const HomeRouter());
    });
  }

  Future<void> processStartupState({
    bool fromLoginRegister = false,
  }) async {
    print('PROCESS STARTUP ${getIt.get<AppStore>().authStatus}');

    if (getIt.get<AppStore>().authStatus is Authorized) {
      print('PROCESS STARTUP ${getIt.get<AppStore>().authStatus}');

      try {
        final infoRequest = await sNetwork.getWalletModule().getSessionInfo();

        infoRequest.pick(
          onData: (info) async {
            final userInfo = getIt.get<UserInfoService>();

            print(info);

            userInfo.updateWithValuesFromSessionInfo(
              twoFaEnabled: info.twoFaEnabled,
              phoneVerified: info.phoneVerified,
              hasDisclaimers: info.hasDisclaimers,
              hasHighYieldDisclaimers: info.hasHighYieldDisclaimers,
            );

            _initSignalRSynchronously();

            if (info.emailVerified) {
              final profileInfoRequest =
                  await sNetwork.getWalletModule().getProfileInfo();

              profileInfoRequest.pick(
                onData: (profileInfo) {
                  userInfo.updateWithValuesFromProfileInfo(
                    emailConfirmed: profileInfo.emailConfirmed,
                    phoneConfirmed: profileInfo.phoneConfirmed,
                    kycPassed: profileInfo.kycPassed,
                    email: profileInfo.email ?? '',
                    phone: profileInfo.phone ?? '',
                    referralLink: profileInfo.referralLink ?? '',
                    referralCode: profileInfo.referralCode ?? '',
                    countryOfRegistration:
                        profileInfo.countryOfRegistration ?? '',
                    countryOfResidence: profileInfo.countryOfResidence ?? '',
                    countryOfCitizenship:
                        profileInfo.countryOfCitizenship ?? '',
                    firstName: profileInfo.firstName ?? '',
                    lastName: profileInfo.lastName ?? '',
                  );
                  if (!info.twoFaPassed) {
                    print('setAuthorizedStatus(const TwoFaVerification(),)');

                    getIt.get<AppStore>().setAuthorizedStatus(
                          const TwoFaVerification(),
                        );
                  } else {
                    _processPinState(
                      fromLoginRegister: fromLoginRegister,
                    );
                  }
                },
                onError: (error) {
                  print('0');
                  print(error.toString());
                },
              );
            } else {
              print('_updateAuthorizedUnion(const EmailVerification());');

              getIt.get<AppStore>().setAuthorizedStatus(
                    const AuthorizedUnion.emailVerification(),
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

  void _processPinState({
    bool fromLoginRegister = false,
  }) {
    print('PIN SETUP');

    final userInfo = getIt.get<UserInfoService>().userInfo;

    if (userInfo.pinEnabled) {
      getIt.get<AppStore>().setAuthorizedStatus(
            const PinVerification(),
          );
    } else {
      if (fromLoginRegister || !userInfo.pinDisabled) {
        getIt.get<AppStore>().setAuthorizedStatus(
              const PinSetup(),
            );
      } else {
        getIt.get<AppStore>().setAuthorizedStatus(
              const Home(),
            );
      }
    }
  }
}
