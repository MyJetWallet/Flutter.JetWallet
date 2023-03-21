import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:local_auth/local_auth.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../core/services/user_info/models/user_info.dart';

class AccountSecurity extends StatefulWidget {
  const AccountSecurity({Key? key}) : super(key: key);

  @override
  State<AccountSecurity> createState() => _AccountSecurityState();
}

class _AccountSecurityState extends State<AccountSecurity> {
  UserInfoState userInfo = getIt.get<UserInfoService>().userInfo;
  bool userInfoDisable =
      getIt.get<UserInfoService>().userInfo.biometricDisabled;

  @override
  void initState() {
    super.initState();
    final userInfoN = getIt.get<UserInfoService>();
    userInfoN.initBiometricStatus();
    startUserInfo();
  }

  void updateUserInfo() {
    setState(() {
      userInfo = getIt.get<UserInfoService>().userInfo;
      userInfoDisable = getIt.get<UserInfoService>().userInfo.biometricDisabled;
    });
  }

  void startUserInfo() {
    Timer(const Duration(milliseconds: 200), () {
      setState(() {
        userInfo = getIt.get<UserInfoService>().userInfo;
        userInfoDisable =
            getIt.get<UserInfoService>().userInfo.biometricDisabled;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.account_security,
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: Column(
        children: <Widget>[
          const SpaceH20(),
          SimpleAccountCategoryButton(
            title: intl.accountSecurity_accountCategoryButtonTitle1,
            icon: const SLockIcon(),
            isSDivider: true,
            onSwitchChanged: (value) async {
              if (userInfo.biometricDisabled) {
                final auth = LocalAuthentication();
                var biometricStatusInfo = BiometricStatus.none;

                final availableBio = await auth.getAvailableBiometrics();
                print(availableBio);

                if (availableBio.contains(BiometricType.face)) {
                  biometricStatusInfo = BiometricStatus.face;
                } else if (availableBio.contains(BiometricType.fingerprint) ||
                    availableBio.contains(BiometricType.strong) ||
                    availableBio.contains(BiometricType.weak)) {
                  biometricStatusInfo = BiometricStatus.fingerprint;
                } else {
                  biometricStatusInfo = BiometricStatus.none;
                }

                if (biometricStatusInfo.toString() ==
                    BiometricStatus.none.toString()) {
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
                await getIt.get<UserInfoService>().disableBiometric();
                updateUserInfo();
              }
            },
            switchValue: !userInfo.biometricDisabled,
          ),
          if (userInfo.pinEnabled)
            SimpleAccountCategoryButton(
              title: intl.accountSecurity_accountPIN,
              showEditIcon: true,
              icon: const SChangePinIcon(),
              isSDivider: false,
              onTap: () => sRouter.push(
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
