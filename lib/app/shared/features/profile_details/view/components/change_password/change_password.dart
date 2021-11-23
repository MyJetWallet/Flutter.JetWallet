import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../auth/shared/components/notifications/show_errror_notification.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../notifier/change_password_notipod.dart';
import '../../../notifier/change_password_state.dart';
import 'components/change_new_password.dart';

class ChangePassword extends HookWidget {
  const ChangePassword({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    useProvider(changePasswordNotipod);
    final notifier = useProvider(changePasswordNotipod.notifier);
    final notificationQueueN = useProvider(sNotificationQueueNotipod.notifier);
    final oldPasswordError = useValueNotifier(StandardFieldErrorNotifier());

    return ProviderListener<ChangePasswordState>(
      provider: changePasswordNotipod,
      onChange: (context, state) {
        state.union.when(
          error: (error) {
            oldPasswordError.value.enableError();
          },
          input: () {},
          done: () {},
        );
      },
      child: SPageFrame(
        color: SColorsLight().grey5,
        header: SPaddingH24(
          child: SSmallHeader(
            title: 'Change Password',
            onBackButtonTap: () => Navigator.pop(context),
          ),
        ),
        child: Column(
          children: [
            Container(
              color: SColorsLight().white,
              padding: EdgeInsets.only(bottom: 14.h),
              child: SPaddingH24(
                child: Baseline(
                  baseline: 24.h,
                  baselineType: TextBaseline.alphabetic,
                  child: Text(
                    'By changing a password will result in a 24- '
                    'hour hold on cryptocurrency withdrawals.',
                    style: sBodyText1Style.copyWith(
                      color: SColorsLight().grey1,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: SColorsLight().white,
              child: SPaddingH24(
                child: SStandardFieldObscure(
                  autofillHints: const [AutofillHints.password],
                  onChanged: (String password) {
                    oldPasswordError.value.disableError();
                    notifier.setOldPassword(password);
                  },
                  autofocus: true,
                  labelText: 'Enter old Password',
                  onErrorIconTap: () {
                    showErrorNotification(
                      notificationQueueN,
                      'Try again that’s not your current password!',
                    );
                  },
                  isErrorValueOn: false,
                  errorNotifier: oldPasswordError.value,
                ),
              ),
            ),
            const Spacer(),
            SPaddingH24(
              child: SPrimaryButton2(
                name: 'Continue',
                onTap: () {
                  notifier.setInput();
                  navigatorPush(
                    context,
                    const ChangeNewPassword(),
                  );
                },
                active:
                    notifier.activeButton() && !oldPasswordError.value.value,
              ),
            ),
            const SpaceH24(),
          ],
        ),
      ),
    );
  }
}
