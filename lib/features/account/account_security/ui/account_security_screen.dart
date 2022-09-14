import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:simple_kit/simple_kit.dart';

class AccountSecurity extends StatelessObserverWidget {
  const AccountSecurity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfo = getIt.get<UserInfoService>().userInfo;
    final userInfoN = sUserInfo;
    userInfoN.initBiometricStatus();

    return SPageFrame(
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
                final biometricStatusInfo = await biometricStatus();
                if (biometricStatusInfo.toString() ==
                    BiometricStatus.none.toString()) {
                  unawaited(
                    getIt.get<AppRouter>().push(
                      const AllowBiometricRoute(),
                    ),
                  );
                } else {
                  unawaited(
                    sRouter.push(
                      BiometricRouter(
                        isAccSettings: true,
                      ),
                    ),
                  );
                }
              } else {
                await getIt.get<UserInfoService>().disableBiometric();
              }
            },
            switchValue: !userInfo.biometricDisabled,
          ),
          if (userInfo.pinEnabled)
            SimpleAccountCategoryButton(
              title: intl.accountSecurity_changePin,
              icon: const SChangePinIcon(),
              isSDivider: true,
              onTap: () => sRouter.push(PinScreenRoute(union: const Change())),
            ),
        ],
      ),
    );
  }
}
