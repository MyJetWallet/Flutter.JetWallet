import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/utils/biometric/biometric_tools.dart';
import 'package:local_auth/local_auth.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

@RoutePage(name: 'AccountSecurityRouter')
class AccountSecurity extends StatefulObserverWidget {
  const AccountSecurity({super.key});

  @override
  State<AccountSecurity> createState() => _AccountSecurityState();
}

class _AccountSecurityState extends State<AccountSecurity> {
  bool userInfoDisable = getIt.get<UserInfoService>().biometricDisabled;

  @override
  void initState() {
    super.initState();
    final userInfoN = getIt.get<UserInfoService>();
    userInfoN.initBiometricStatus();
    startUserInfo();
  }

  void updateUserInfo() {
    setState(() {
      userInfoDisable = getIt.get<UserInfoService>().biometricDisabled;
    });
  }

  void startUserInfo() {
    Timer(const Duration(milliseconds: 200), () {
      setState(() {
        userInfoDisable = getIt.get<UserInfoService>().biometricDisabled;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: GlobalBasicAppBar(
        title: intl.account_security,
        hasRightIcon: false,
      ),
      child: Column(
        children: <Widget>[
          SEditable(
            lable: intl.accountSecurity_accountCategoryButtonTitle1,
            leftIcon: Assets.svg.medium.lock.simpleSvg(),
            rightIcon: Container(
              width: 40.0,
              height: 22.0,
              decoration: BoxDecoration(
                color: !getIt.get<UserInfoService>().biometricDisabled ? Colors.black : Colors.grey,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Switch(
                value: !getIt.get<UserInfoService>().biometricDisabled,
                onChanged: (value) async {
                  if (getIt.get<UserInfoService>().biometricDisabled) {
                    final auth = LocalAuthentication();
                    var biometricStatusInfo = BiometricStatus.none;

                    final availableBio = await auth.getAvailableBiometrics();

                    if (availableBio.contains(BiometricType.face)) {
                      biometricStatusInfo = BiometricStatus.face;
                    } else if (availableBio.contains(BiometricType.fingerprint) ||
                        availableBio.contains(BiometricType.strong) ||
                        availableBio.contains(BiometricType.weak)) {
                      biometricStatusInfo = BiometricStatus.fingerprint;
                    } else {
                      biometricStatusInfo = BiometricStatus.none;
                    }

                    if (biometricStatusInfo.toString() == BiometricStatus.none.toString()) {
                      unawaited(
                        getIt.get<AppRouter>().push(
                              const AllowBiometricRoute(),
                            ),
                      );
                    } else {
                      await sRouter.push(
                        BiometricRouter(
                          isAccSettings: true,
                        ),
                      );
                    }
                    updateUserInfo();
                  } else {
                    getIt.get<UserInfoService>().updateBiometric(
                          hideBiometric: true,
                        );
                    updateUserInfo();
                  }
                },
                activeColor: Colors.white,
                activeTrackColor: Colors.black,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey,
              ),
            ),
          ),
          if (getIt.get<UserInfoService>().pinEnabled)
            SEditable(
              lable: intl.accountSecurity_accountPIN,
              leftIcon: Assets.svg.medium.pin.simpleSvg(),
              rightIcon: Assets.svg.medium.edit.simpleSvg(),
              onCardTap: () => sRouter.push(
                PinScreenRoute(
                  union: const Change(),
                  fromRegister: false,
                  isChangePin: true,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
