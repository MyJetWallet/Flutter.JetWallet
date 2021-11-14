import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/components/security_divider.dart';
import '../../../../../shared/components/security_option.dart';
import '../../../../../shared/features/pin_screen/model/pin_flow_union.dart';
import '../../../../../shared/features/pin_screen/view/pin_screen.dart';
import '../../../../../shared/features/two_fa/two_fa_screen/two_fa_screen.dart';
import '../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import 'components/security_protection.dart';

class AccountSecurity extends HookWidget {
  const AccountSecurity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfo = useProvider(userInfoNotipod);

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: 'Security',
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: Column(
        children: <Widget>[
          const SpaceH20(),
          const SecurityProtection(),
          const SpaceH20(),
          SimpleAccountCategoryButton(
            title: 'Face / Touch ID & PIN',
            icon: const STouchAndPinIcon(),
            isSDivider: true,
            onSwitchChanged: (value) {
              if (userInfo.pinEnabled) {
                PinScreen.push(context, const Disable());
              } else {
                PinScreen.push(context, const Enable());
              }
            },
            switchValue: userInfo.pinEnabled,
          ),
          if (userInfo.pinEnabled)
            SimpleAccountCategoryButton(
              title: 'Change PIN',
              icon: const SChangePinIcon(),
              isSDivider: true,
              onTap: () => PinScreen.push(context, const Change()),
            ),
          SimpleAccountCategoryButton(
            title: '2-Factor authentication',
            icon: const STwoFactorAuthIcon(),
            isSDivider: false,
            onTap: () => TwoFaScreen.push(context),
          ),
        ],
      ),
    );
  }
}
