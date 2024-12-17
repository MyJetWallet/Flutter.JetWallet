import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/device_info/device_info.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/auth/biometric/store/biometric_store.dart';
import 'package:jetwallet/utils/biometric/biometric_tools.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';

import '../../../../core/services/apps_flyer_service.dart';

@RoutePage(name: 'BiometricRouter')
class Biometric extends StatelessWidget {
  const Biometric({
    super.key,
    this.isAccSettings = false,
  });

  final bool isAccSettings;

  @override
  Widget build(BuildContext context) {
    return Provider<BiometricStore>(
      create: (context) => BiometricStore(),
      builder: (context, child) => _BiometricBody(
        isAccSettings: isAccSettings,
      ),
    );
  }
}

class _BiometricBody extends StatelessObserverWidget {
  const _BiometricBody({
    this.isAccSettings = false,
  });

  final bool isAccSettings;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    final biometric = BiometricStore.of(context);
    final size = MediaQuery.of(context).size;
    final deviceInfo = sDeviceInfo;
    final iosLatest = deviceInfo.marketingName.contains('iPhone 11') ||
        deviceInfo.marketingName.contains('iPhone 12') ||
        deviceInfo.marketingName.contains('iPhone 13') ||
        deviceInfo.marketingName.contains('iPhone 14') ||
        deviceInfo.marketingName.contains('iPhone X') ||
        deviceInfo.marketingName.contains('iPhone x');

    late String headerText;
    late String buttonText;
    late String image;

    return FutureBuilder<BiometricStatus>(
      future: biometricStatus(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == BiometricStatus.face || iosLatest) {
            sAnalytics.signInFlowEnableBiometricView(
              biometric: 'Face ID',
            );
            headerText = intl.bio_screen_face_id_title;
            buttonText = intl.bio_screen_face_id_button_text;
            image = bioFaceId;
          } else {
            sAnalytics.signInFlowEnableBiometricView(
              biometric: 'Biometrics',
            );
            headerText = intl.bio_screen_touch_id_title;
            buttonText = intl.bio_screen_touch_id_button_text;
            image = bioTouchId;
          }

          return SPageFrame(
            loaderText: intl.register_pleaseWait,
            header: SimpleLargeAppbar(
              hasLeftIcon: false,
              title: headerText,
              titleMaxLines: 2,
            ),
            child: SPaddingH24(
              child: Column(
                children: [
                  const Spacer(),
                  Image.asset(
                    image,
                    height: size.width * 0.6,
                  ),
                  const Spacer(),
                  Text(
                    intl.bio_screen_text,
                    maxLines: 2,
                    style: STStyles.body1Medium.copyWith(
                      color: colors.gray10,
                    ),
                  ),
                  const SpaceH40(),
                  SButton.blue(
                    text: buttonText,
                    callback: () async {
                      final bioStatus = await biometricStatus();
                      final storageService = sLocalStorageService;
                      await storageService.setString(useBioKey, 'true');
                      final userInfoN = getIt.get<UserInfoService>();
                      await userInfoN.initBiometricStatus();

                      if (bioStatus == BiometricStatus.none) {
                        await getIt.get<AppRouter>().push(
                              const AllowBiometricRoute(),
                            );
                      } else {
                        if (userInfoN.isJustLogged) {
                          sAnalytics.signInFlowVerificationPassed();
                          final appsFlyerService = getIt.get<AppsFlyerService>();
                          final userInfo = getIt.get<UserInfoService>();

                          final appsFlyerID = await appsFlyerService.appsflyerSdk.getAppsFlyerUID();
                          final bytes = utf8.encode(userInfo.email);
                          final hashEmail = sha256.convert(bytes).toString();
                          appsFlyerService.appsflyerSdk.setCustomerUserId(hashEmail);

                          await appsFlyerService.appsflyerSdk.logEvent('af_registration_finished', {
                            'IsTechAcc': '${userInfo.isTechClient}',
                            'Customer User iD': hashEmail,
                            'Appsflyer ID': appsFlyerID,
                          });
                        }

                        biometric.useBio(
                          useBio: true,
                          isAccSettings: isAccSettings,
                        );
                      }
                    },
                  ),
                  const SpaceH10(),
                  SButton.text(
                    text: intl.bio_screen_button_late_text,
                    callback: () async {
                      if (isAccSettings) {
                        Navigator.pop(context);
                      } else {
                        final userInfoN = getIt.get<UserInfoService>();
                        if (userInfoN.isJustLogged) {
                          sAnalytics.signInFlowVerificationPassed();
                          final appsFlyerService = getIt.get<AppsFlyerService>();
                          final userInfo = getIt.get<UserInfoService>();

                          final appsFlyerID = await appsFlyerService.appsflyerSdk.getAppsFlyerUID();
                          final bytes = utf8.encode(userInfo.email);
                          final hashEmail = sha256.convert(bytes).toString();
                          appsFlyerService.appsflyerSdk.setCustomerUserId(hashEmail);
                          await appsFlyerService.appsflyerSdk.logEvent('af_registration_finished', {
                            'IsTechAcc': '${userInfo.isTechClient}',
                            'Customer User iD': hashEmail,
                            'Appsflyer ID': appsFlyerID,
                          });
                        }

                        biometric.useBio(
                          useBio: false,
                        );
                      }
                    },
                  ),
                  const SpaceH42(),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
