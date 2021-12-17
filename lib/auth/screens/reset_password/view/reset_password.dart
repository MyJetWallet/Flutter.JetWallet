import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../shared/helpers/navigator_push.dart';
import '../../../shared/components/password_validation/password_validation.dart';
import '../../login/login.dart';
import '../notifier/reset_password_notipod.dart';
import '../notifier/reset_password_state.dart';
import '../notifier/reset_password_union.dart';

class ResetPassword extends HookWidget {
  const ResetPassword({
    Key? key,
    required this.token,
  }) : super(key: key);

  final String token;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final reset = useProvider(resetPasswordNotipod);
    final resetN = useProvider(resetPasswordNotipod.notifier);
    final notificationQueueN = useProvider(sNotificationQueueNotipod.notifier);

    return ProviderListener<ResetPasswordState>(
      provider: resetPasswordNotipod,
      onChange: (context, state) {
        state.union.maybeWhen(
          error: (error) {
            sShowErrorNotification(
              notificationQueueN,
              '$error',
            );
          },
          orElse: () {},
        );
      },
      child: SPageFrame(
        color: colors.grey5,
        header: SPaddingH24(
          child: SBigHeader(
            title: 'Password reset',
            onBackButtonTap: () => Navigator.of(context).pop(),
          ),
        ),
        child: AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: colors.white,
                child: SPaddingH24(
                  child: SStandardFieldObscure(
                    autofillHints: const [AutofillHints.password],
                    onChanged: (value) {
                      resetN.updateAndValidatePassword(value);
                    },
                    labelText: 'Password',
                    autofocus: true,
                  ),
                ),
              ),
              SPaddingH24(
                child: PasswordValidation(
                  password: reset.password,
                ),
              ),
              const Spacer(),
              SPaddingH24(
                child: SPrimaryButton2(
                  active: reset.passwordValid,
                  name: 'Continue',
                  onTap: () {
                    if (reset.passwordValid) {
                      resetN.resetPassword(token);

                      if (reset.union is Input) {
                        _pushToAuthSuccess(context);
                      }
                    }
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

void _pushToAuthSuccess(BuildContext context) {
  return SuccessScreen.push(
    context: context,
    secondaryText: 'Your password has been reset',
    then: () {
      navigatorPush(context, const Login());
    },
  );
}
