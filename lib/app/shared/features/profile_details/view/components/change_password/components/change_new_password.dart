import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../auth/shared/components/notifications/show_errror_notification.dart';
import '../../../../../../../../auth/shared/components/password_validation/password_validation.dart';
import '../../../../../../../../auth/shared/notifiers/credentials_notifier/credentials_notipod.dart';
import '../../../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../notifier/change_password_notipod.dart';
import '../../../../notifier/change_password_state.dart';

class ChangeNewPassword extends HookWidget {
  const ChangeNewPassword({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final credentials = useProvider(credentialsNotipod);
    final credentialsN = useProvider(credentialsNotipod.notifier);
    final notifier = useProvider(changePasswordNotipod.notifier);
    useProvider(changePasswordNotipod);
    final notificationQueueN = useProvider(sNotificationQueueNotipod.notifier);
    final loading = useValueNotifier(StackLoaderNotifier());

    return ProviderListener<ChangePasswordState>(
      provider: changePasswordNotipod,
      onChange: (context, state) {
        state.union.when(
          error: (error) {
            loading.value.finishLoading();
            showErrorNotification(
              notificationQueueN,
              '$error',
            );
            Navigator.of(context).pop();
          },
          input: () {},
          done: () {
            navigatorPush(
              context,
              const SuccessScreen(
                text1: 'New password set',
              ),
            );
          },
        );
      },
      child: SPageFrame(
        color: SColorsLight().grey5,
        header: SPaddingH24(
          child: SSmallHeader(
            title: 'Create a password',
            onBackButtonTap: () => Navigator.of(context).pop(),
          ),
        ),
        loading: loading.value,
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: SColorsLight().white,
                child: SPaddingH24(
                  child: SStandardFieldObscure(
                    autofillHints: const [AutofillHints.password],
                    onChanged: (String password) {
                      notifier.setNewPassword(password);
                      credentialsN.updateAndValidatePassword(password);
                    },
                    labelText: 'Create a new Password',
                    autofocus: true,
                  ),
                ),
              ),
              SPaddingH24(
                child: PasswordValidation(
                  password: credentials.password,
                ),
              ),
              const Spacer(),
              SPaddingH24(
                child: SPrimaryButton2(
                  active: true,
                  name: 'Set new password',
                  onTap: () {
                    loading.value.startLoading();
                    notifier.confirmNewPassword();
                  },
                ),
              ),
              const SpaceH24(),
            ],
          ),
        ),
      ),
    );
  }
}
