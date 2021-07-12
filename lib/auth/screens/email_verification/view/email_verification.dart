import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/components/loader.dart';
import '../../../../shared/components/spacers.dart';
import '../../../../shared/helpers/show_plain_snackbar.dart';
import '../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../shared/auth_button_grey.dart';
import '../../../shared/auth_frame.dart';
import '../../../shared/auth_header_text.dart';
import '../../../shared/open_my_email_button.dart';
import '../../sign_in_up/notifier/auth_model_notifier/auth_model_notipod.dart';
import '../notifier/email_verification_notipod.dart';
import '../notifier/email_verification_state.dart';
import '../notifier/email_verification_union.dart';
import 'components/email_verification_text.dart';
import 'components/email_verification_text_field.dart';
import 'components/resend_button.dart';
import 'components/resend_in_text.dart';

class EmailVerification extends HookWidget {
  const EmailVerification({
    Key? key,
    this.code,
  }) : super(key: key);

  final String? code;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(emailVerificationNotipod);
    final notifier = useProvider(emailVerificationNotipod.notifier);
    final timer = useProvider(timerNotipod(5));
    final timerN = useProvider(timerNotipod(5).notifier);
    final authModel = useProvider(authModelNotipod);

    return ProviderListener<EmailVerificationState>(
      provider: emailVerificationNotipod,
      onChange: (context, verificationState) {
        verificationState.union.maybeWhen(
          error: (Object? error) {
            showPlainSnackbar(context, '$error');
          },
          orElse: () {},
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: AuthScreenFrame(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeaderText(
                text: 'Email Verification',
              ),
              const SpaceH15(),
              const EmailVerificationText(
                text: 'Check your email on this device to verify your account',
              ),
              const SpaceH40(),
              if (state.union is Loading)
                Loader()
              else ...[
                EmailVerificationText(
                  text: 'Sent to ${authModel.email}',
                ),
                const SpaceH4(),
                if (timer != 0)
                  ResendInText(seconds: timer)
                else ...[
                  const SpaceH4(),
                  ResendButton(
                    onTap: () async {
                      await notifier.sendCode();

                      if (state.union is Input) {
                        timerN.refreshTimer();
                      }
                    },
                  ),
                ],
                const SpaceH40(),
                EmailVerificationTextField(
                  controller: state.controller,
                ),
                const Spacer(),
                const OpenMyEmailButton(),
                const SpaceH10(),
                AuthButtonGrey(
                  text: 'Continue',
                  onTap: () => notifier.verifyCode(),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
