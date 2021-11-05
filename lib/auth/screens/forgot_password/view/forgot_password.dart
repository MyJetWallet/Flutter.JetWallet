import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/helpers/navigator_push.dart';
import '../../../shared/components/notifications/show_errror_notification.dart';
import '../notifier/forgot_password_notipod.dart';
import '../notifier/forgot_password_state.dart';
import '../notifier/forgot_password_union.dart';
import 'components/check_your_email.dart';

class ForgotPassword extends StatefulHookWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final forgot = useProvider(forgotPasswordNotipod);
    final forgotN = useProvider(forgotPasswordNotipod.notifier);
    final notificationQueueN = useProvider(sNotificationQueueNotipod.notifier);
    final emailError = useValueNotifier(StandardFieldErrorNotifier());

    return ProviderListener<ForgotPasswordState>(
      provider: forgotPasswordNotipod,
      onChange: (context, state) {
        state.union.maybeWhen(
          error: (error) {
            showErrorNotification(
              notificationQueueN,
              'Some error occurred.',
            );
          },
          orElse: () {},
        );
      },
      child: SPageFrame(
        header: SPaddingH24(
          child: SBigHeader(
            title: 'Forgot Password',
            onBackButtonTap: () => Navigator.pop(context),
          ),
        ),
        child: AutofillGroup(
          child: Expanded(
            child: Material(
              color: colors.grey5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Material(
                    color: colors.white,
                    child: Column(
                      children: [
                        const SpaceH7(),
                        SPaddingH24(
                          child: Text(
                            'Resetting a forgotten password will logout other'
                            ' devices and will result in a 24-hour hold on'
                            ' cryptocurrency withdrawals.',
                            style:
                                sBodyText1Style.copyWith(color: colors.grey1),
                            maxLines: 3,
                          ),
                        ),
                        const SpaceH16(),
                      ],
                    ),
                  ),
                  Material(
                    color: colors.white,
                    child: SPaddingH24(
                      child: SStandardField(
                        labelText: 'Email Address',
                        autofocus: true,
                        autofillHints: const [AutofillHints.email],
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          emailError.value.disableError();
                          forgotN.updateAndValidateEmail(value);
                        },
                        onErrorIconTap: () {
                          showErrorNotification(
                            notificationQueueN,
                            'Perhaps you missed "." or "@" somewhere?',
                          );
                        },
                        errorNotifier: emailError.value,
                      ),
                    ),
                  ),
                  const Spacer(),
                  SPaddingH24(
                    child: SPrimaryButton2(
                      name: 'Reset password',
                      onTap: () async {
                        if (forgot.emailValid) {
                          final email = forgot.email;

                          await forgotN.sendRecoveryLink();

                          if (forgot.union is Input) {
                            if (!mounted) return;
                            navigatorPush(context, CheckYourEmail(email));
                          }
                        } else {
                          emailError.value.enableError();
                          showErrorNotification(
                            notificationQueueN,
                            'Perhaps you missed "." or "@" somewhere?',
                          );
                        }
                      },
                      active: forgotN.emailIsNotEmpty,
                    ),
                  ),
                  const SpaceH24(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
