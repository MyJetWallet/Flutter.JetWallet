import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../auth/screens/biometric/biometric.dart';
import '../../../../../auth/screens/biometric/notifier/biometric_status_notifier.dart';
import '../../../../../shared/features/pin_screen/model/pin_flow_union.dart';
import '../../../../../shared/features/pin_screen/view/pin_screen.dart';
import '../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../../shared/providers/service_providers.dart';
import 'components/allow_biometric.dart';

class AccountSecurity extends HookWidget {
  const AccountSecurity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final biometricStatus = useProvider(biometricStatusFpod);
    final userInfo = useProvider(userInfoNotipod);
    final userInfoN = useProvider(userInfoNotipod.notifier);
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
                if (biometricStatus.data?.value.toString() ==
                    BiometricStatus.none.toString()) {
                  AllowBiometric.push(context: context);
                } else {
                  Biometric.push(context: context, isAccSettings: true);
                }
              } else {
                await userInfoN.disableBiometric();
              }
            },
            switchValue: !userInfo.biometricDisabled,
          ),
          if (userInfo.pinEnabled)
            SimpleAccountCategoryButton(
              title: intl.accountSecurity_changePin,
              icon: const SChangePinIcon(),
              isSDivider: true,
              onTap: () => PinScreen.push(context, const Change()),
            ),
        ],
      ),
    );
  }
}
