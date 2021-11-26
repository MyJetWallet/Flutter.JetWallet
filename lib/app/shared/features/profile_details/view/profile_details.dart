import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/constants.dart';
import '../../../../../shared/features/phone_verification/phone_verification_confirm/view/phone_verification_confirm.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/notifiers/phone_number_notifier/phone_number_notipod.dart';
import '../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../notifier/change_phone_notipod.dart';
import 'components/change_password/change_password.dart';
import 'components/change_phone_number/change_phone_number.dart';

class ProfileDetails extends HookWidget {
  const ProfileDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userInfo = useProvider(userInfoNotipod);
    final phoneNumberN = useProvider(phoneNumberNotipod.notifier);

    final changePhone = useProvider(changePhoneNotipod);

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
          if (userInfo.enableChangePhoneNumber)
            SProfileDetailsButton(
              label: 'Change phone number',
              value: userInfo.phone,
              onTap: () {
                sShowWarningPopup(
                  context,
                  asset: ellipsisAsset,
                  primaryText: 'Pay attention',
                  primaryButtonName: 'Continue',
                  onPrimaryButtonTap: (BuildContext builderContext) {
                    Navigator.pop(builderContext);
                    phoneNumberN.updatePhoneNumber(
                      changePhone.isoCode + changePhone.phone,
                    );
                    PhoneVerificationConfirm.push(
                      context,
                      () {
                        navigatorPush(context, const ChangePhoneNumber());
                      },
                      isChangeFonAlert: true,
                    );
                  },
                  secondaryText: 'Withdrawals will be blocked within 24 hours',
                  secondaryButtonName: 'Cancel',
                  onSecondaryButtonTap: (BuildContext builderContext) {
                    Navigator.pop(builderContext);
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
