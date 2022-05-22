import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/features/pin_screen/model/pin_flow_union.dart';
import '../../../../../shared/features/pin_screen/view/pin_screen.dart';
import '../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../sms_autheticator/sms_authenticator.dart';
import 'components/security_protection.dart';

class AccountSecurity extends HookWidget {
  const AccountSecurity({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final userInfo = useProvider(userInfoNotipod);

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
          const SPaddingH24(
            child: SecurityProtection(),
          ),
          const SpaceH40(),
          SimpleAccountCategoryButton(
            title: intl.accountSecurity_accountCategoryButtonTitle1,
            icon: const SLockIcon(),
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
              title: intl.accountSecurity_changePin,
              icon: const SChangePinIcon(),
              isSDivider: true,
              onTap: () => PinScreen.push(context, const Change()),
            ),
          SimpleAccountCategoryButton(
            title: intl.accountSecurity_accountCategoryButtonTitle3,
            icon: const STwoFactorAuthIcon(),
            isSDivider: false,
            onTap: () => SmsAuthenticator.push(context),
          ),
        ],
      ),
    );
  }
}
