import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../auth/shared/helpers/password_validators.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../notifier/change_password_notifier/change_password_notipod.dart';
import '../../../notifier/change_password_notifier/change_password_state.dart';
import 'components/set_new_password.dart';

class ChangePassword extends HookWidget {
  const ChangePassword({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final changePassword = useProvider(changePasswordNotipod);
    final changePasswordN = useProvider(changePasswordNotipod.notifier);
    final notificationQueueN = useProvider(sNotificationQueueNotipod.notifier);
    final oldPasswordError = useValueNotifier(StandardFieldErrorNotifier());
    final colors = useProvider(sColorPod);

    return ProviderListener<ChangePasswordState>(
      provider: changePasswordNotipod,
      onChange: (context, state) {
        state.union.maybeWhen(
          error: (error) {
            oldPasswordError.value.enableError();
          },
          orElse: () {},
        );
      },
      child: SPageFrame(
        color: colors.grey5,
        header: SPaddingH24(
          child: SSmallHeader(
            title: 'Change Password',
            onBackButtonTap: () => Navigator.pop(context),
          ),
        ),
        child: Column(
          children: [
            Container(
              color: colors.white,
              padding: EdgeInsets.only(bottom: 14.h),
              child: SPaddingH24(
                child: Baseline(
                  baseline: 24.h,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    'By changing a password will result in a 24- '
                    'hour hold on cryptocurrency withdrawals.',
                    style: sBodyText1Style.copyWith(
                      color: colors.grey1,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: colors.white,
              child: SPaddingH24(
                child: SStandardFieldObscure(
                  autofillHints: const [AutofillHints.password],
                  onChanged: (String password) {
                    changePasswordN.setInput();
                    changePasswordN.setOldPassword(password);
                  },
                  autofocus: true,
                  labelText: 'Enter old Password',
                  onErrorIconTap: () {
                    sShowErrorNotification(
                      notificationQueueN,
                      'Try again that’s not your current password!',
                    );
                  },
                  errorNotifier: oldPasswordError.value,
                ),
              ),
            ),
            const Spacer(),
            SPaddingH24(
              child: SPrimaryButton2(
                name: 'Continue',
                onTap: () {
                  navigatorPush(
                    context,
                    const SetNewPassword(),
                  );
                },
                active: isPasswordValid(changePassword.oldPassword),
              ),
            ),
            const SpaceH24(),
          ],
        ),
      ),
    );
  }
}
