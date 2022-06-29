import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../delete_profile/view/delete_profile.dart';
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
                primaryText: intl.profileDetails_payAttention,
                secondaryText: '${intl.profileDetails_changePasswordAlert} '
                    '$changePasswordLockHours ${intl.hours}.',
                primaryButtonName: intl.profileDetails_continue,
                image: _infoImage,
                onPrimaryButtonTap: () {
                  navigatorPushReplacement(context, const ChangePassword());
                },
                secondaryButtonName: intl.profileDetails_cancel,
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
                  secondaryText: '${intl.profileDetails_changePhoneAlert} '
                      '$changePhoneLockHours ${intl.hours}.',
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
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
            child: SSecondaryButton1(
              active: true,
              icon: const SCircleMinusIcon(),
              name: intl.profileDetails_deleteProfile,
              onTap: () {
                sShowAlertPopup(
                  context,
                  primaryText: '${intl.profileDetails_deleteProfile}?',
                  secondaryText: intl.profileDetails_deleteProfileDescr,
                  primaryButtonName: intl.profileDetails_deleteProfile,
                  primaryButtonType: SButtonType.primary3,
                  onPrimaryButtonTap: () => {
                    navigatorPush(context, const DeleteProfile()),
                  },
                  isNeedCancelButton: true,
                  cancelText: intl.profileDetails_cancel,
                  onCancelButtonTap: () => {Navigator.pop(context)},
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
