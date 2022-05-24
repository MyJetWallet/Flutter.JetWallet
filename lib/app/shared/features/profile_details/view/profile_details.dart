import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../phone_verification/view/phone_verification.dart';
import '../../set_phone_number/view/set_phone_number.dart';
import 'components/change_password/change_password.dart';

class ProfileDetails extends HookWidget {
  const ProfileDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final userInfo = useProvider(userInfoNotipod);

    final _infoImage = Image.asset(
      phoneChangeAsset,
      width: 80,
      height: 80,
      package: 'simple_kit',
    );

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: intl.profileDetails_profileDetails,
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: Column(
        children: [
          SProfileDetailsButton(
            label: intl.profileDetails_email,
            value: userInfo.email,
            onTap: () {},
          ),
          SProfileDetailsButton(
            label: intl.profileDetails_changePassword,
            value: '• • • • • • • • • • •',
            onTap: () {
              sShowAlertPopup(
                context,
                willPopScope: false,
                primaryText: 'Pay attention',
                secondaryText: 'When changing the password, the '
                    'withdrawal of funds will be locked for '
                    '$changePasswordLockHours hours.',
                primaryButtonName: 'Continue',
                image: _infoImage,
                onPrimaryButtonTap: () {
                  navigatorPushReplacement(context, const ChangePassword());
                },
                secondaryButtonName: 'Cancel',
                onSecondaryButtonTap: () {
                  Navigator.pop(context);
                },
              );
            },
          ),
          if (userInfo.isPhoneNumberSet)
            SProfileDetailsButton(
              label: intl.profileDetails_changePhoneNumber,
              value: userInfo.phone,
              onTap: () {
                sShowAlertPopup(
                  context,
                  willPopScope: false,
                  primaryText: intl.profileDetails_payAttention,
                  secondaryText: 'When changing the phone number, the '
                      'withdrawal of funds will be locked for '
                      '$changePhoneLockHours hours.',
                  // secondaryText: '${intl.profileDetails_buttonSecondaryText}.',
                  primaryButtonName: intl.profileDetails_continue,
                  image: _infoImage,
                  onPrimaryButtonTap: () {
                    PhoneVerification.pushReplacement(
                      context: context,
                      args: PhoneVerificationArgs(
                        phoneNumber: userInfo.phone,
                        showChangeTextAlert: true,
                        onVerified: () {
                          SetPhoneNumber.pushReplacement(
                            context: context,
                            successText:
                                intl.profileDetails_newPhoneNumberConfirmed,
                          );
                        },
                      ),
                    );
                  },
                  secondaryButtonName: intl.profileDetails_cancel,
                  onSecondaryButtonTap: () {
                    Navigator.pop(context);
                  },
                );
              },
            ),
        ],
      ),
    );
  }
}
