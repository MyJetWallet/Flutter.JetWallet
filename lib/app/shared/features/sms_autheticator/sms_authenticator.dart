import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/features/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import '../../../../shared/features/two_fa_phone/view/two_fa_phone.dart';
import '../../../../shared/helpers/navigator_push.dart';
import '../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../phone_number/view/set_phone_number.dart';
import 'components/show_sms_auth_warning.dart';

class SmsAuthenticator extends HookWidget {
  const SmsAuthenticator({Key? key}) : super(key: key);

  static void push(BuildContext context) {
    navigatorPush(context, const SmsAuthenticator());
  }

  @override
  Widget build(BuildContext context) {
    final userInfo = useProvider(userInfoNotipod);

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: 'SMS Authenticator',
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: Column(
        children: [
          SimpleAccountCategoryButton(
            title: 'SMS Authenticator',
            icon: const SLockIcon(),
            isSDivider: false,
            switchValue: userInfo.twoFaEnabled,
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
                  PhoneNumber.push(
                    context: context,
                    successText: '2-Factor verification enabled',
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
