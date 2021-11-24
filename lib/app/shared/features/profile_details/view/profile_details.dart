import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import 'components/change_password/change_password.dart';

class ProfileDetails extends HookWidget {
  const ProfileDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authInfo = useProvider(authInfoNotipod);

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
            value: authInfo.email,
            onTap: () {},
          ),
          SProfileDetailsButton(
            label: 'Change password',
            value: '• • • • • • • • • • •',
            onTap: () {
              navigatorPush(context, const ChangePassword());
            },
          ),
          SProfileDetailsButton(
            label: 'Change phone number',
            value: '+380 (93) 447 1844',
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
