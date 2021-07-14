import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/components/loader.dart';
import '../../../../shared/components/spacers.dart';
import '../../../../shared/helpers/show_plain_snackbar.dart';
import '../../../../shared/notifiers/logout_notifier/logout_notipod.dart';
import '../../../../shared/notifiers/logout_notifier/logout_union.dart' as lu;
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
import 'components/logout_button.dart';
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
    final timer = useProvider(timerNotipod(5));
    final timerN = useProvider(timerNotipod(5).notifier);
    final logout = useProvider(logoutNotipod);
    final verification = useProvider(emailVerificationNotipod);
    final verificationN = useProvider(emailVerificationNotipod.notifier);
    final authModel = useProvider(authModelNotipod);

    return ProviderListener<EmailVerificationState>(
      provider: emailVerificationNotipod,
      onChange: (context, state) {
        state.union.maybeWhen(
          error: (Object? error) {
            showPlainSnackbar(context, '$error');
          },
          orElse: () {},
        );
      },
      child: ProviderListener<lu.LogoutUnion>(
        provider: logoutNotipod,
        onChange: (context, union) {
          union.when(
            result: (error, st) {
              if (error != null) {
                showPlainSnackbar(context, '$error');
              }
            },
            loading: () {},
          );
        },
        child: logout.when(
          result: (_, __) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body: AuthScreenFrame(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LogoutButton(),
                    const AuthHeaderText(
                      text: 'Email Verification',
                    ),
                    const SpaceH15(),
                    const EmailVerificationText(
                      text: 'Enter the code we have sent you to your email',
                    ),
                    const SpaceH40(),
                    if (verification.union is Loading)
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
                            await verificationN.sendCode();

                            if (verification.union is Input) {
                              timerN.refreshTimer();
                            }
                          },
                        ),
                      ],
                      const SpaceH40(),
                      EmailVerificationTextField(
                        controller: verification.controller,
                      ),
                      const Spacer(),
                      const OpenMyEmailButton(),
                      const SpaceH10(),
                      AuthButtonGrey(
                        text: 'Continue',
                        onTap: () => verificationN.verifyCode(),
                      ),
                    ]
                  ],
                ),
              ),
            );
          },
          loading: () => Loader(),
        ),
      ),
    );
  }
}
