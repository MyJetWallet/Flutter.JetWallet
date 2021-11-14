import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../helpers/navigator_push.dart';
import '../../../notifiers/user_info_notifier/user_info_notipod.dart';
import '../../phone_verification/phone_verification_enter/phone_verification_enter.dart';
import '../two_fa_phone/model/two_fa_phone_trigger_union.dart';
import '../two_fa_phone/view/two_fa_phone.dart';
import 'components/show_sms_auth_warning.dart';

class TwoFaScreen extends HookWidget {
  const TwoFaScreen({Key? key}) : super(key: key);

  static void push(BuildContext context) {
    navigatorPush(context, const TwoFaScreen());
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = useProvider(userInfoNotipod);

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: '2-Factor authentication',
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: Column(
        children: <Widget>[
          SimpleAccountCategoryButton(
            title: 'SMS Authenticator',
            icon: const SLockIcon(),
            isSDivider: false,
            onSwitchChanged: (value) {
              if (userInfo.twoFaEnabled) {
                showSmsAuthWarning(context);
              } else {
                if (userInfo.phoneVerified) {
                  TwoFaPhone.push(
                    context,
                    const TwoFaPhoneTriggerUnion.security(
                      fromDialog: false,
                    ),
                  );
                } else {
                  PhoneVerificationEnter.push(
                    context: context,
                    onVerified: () {
                      // TODO reconsider navigation practices
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                  );
                }
              }
            },
            switchValue: userInfo.pinEnabled,
          ),
        ],
      ),
    );
  }
}
