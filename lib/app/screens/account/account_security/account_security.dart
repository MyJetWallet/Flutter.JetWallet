import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/components/page_frame/page_frame.dart';
import '../../../../shared/components/spacers.dart';
import '../../../../shared/features/pin_screen/model/pin_flow_union.dart';
import '../../../../shared/features/pin_screen/view/pin_screen.dart';
import '../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import 'components/security_divider.dart';
import 'components/security_option.dart';
import 'components/security_protection.dart';

class AccountSecurity extends HookWidget {
  const AccountSecurity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfo = useProvider(userInfoNotipod);

    return PageFrame(
      header: 'Security',
      onBackButton: () => Navigator.pop(context),
      child: Column(
        children: [
          const SpaceH20(),
          const SecurityProtection(),
          const SpaceH20(),
          SecurityOption(
            name: 'PIN / Biometrics',
            icon: Icons.person,
            onSwitchChanged: (value) {
              if (userInfo.pinEnabled) {
                PinScreen.push(context, const Disable());
              } else {
                PinScreen.push(context, const Enable());
              }
            },
            switchValue: userInfo.pinEnabled,
          ),
          const SecurityDivider(),
          if (userInfo.pinEnabled)
            SecurityOption(
              name: 'Change PIN',
              icon: Icons.password,
              onTap: () => PinScreen.push(context, const Change()),
            ),
          const SecurityDivider(),
          SecurityOption(
            name: '2-Factor authentication',
            icon: Icons.lock,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
