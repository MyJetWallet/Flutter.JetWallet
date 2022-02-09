import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../phone_verification/view/phone_verification.dart';
import '../../set_phone_number/view/set_phone_number.dart';
import 'components/change_password/change_password.dart';

class ProfileDetails extends HookWidget {
  const ProfileDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfo = useProvider(userInfoNotipod);

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: 'Profile details',
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: Column(
        children: [
          SProfileDetailsButton(
            label: 'Email',
            value: userInfo.email,
            onTap: () {},
          ),
          SProfileDetailsButton(
            label: 'Change password',
            value: '• • • • • • • • • • •',
            onTap: () {
              navigatorPush(context, const ChangePassword());
            },
          ),
          if (userInfo.isPhoneNumberSet)
            SProfileDetailsButton(
              label: 'Change phone number',
              value: userInfo.phone,
              onTap: () {
                PhoneVerification.push(
                  context: context,
                  args: PhoneVerificationArgs(
                    phoneNumber: userInfo.phone,
                    showChangeTextAlert: true,
                    onVerified: () {
                      SetPhoneNumber.pushReplacement(
                        context: context,
                        successText: 'New phone number confirmed',
                      );
                    },
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
