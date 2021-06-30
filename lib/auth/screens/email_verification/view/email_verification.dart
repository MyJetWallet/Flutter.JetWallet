import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/components/loader.dart';
import '../../../../shared/components/spacers.dart';
import '../../../../shared/helpers/show_plain_snackbar.dart';
import '../../../../shared/providers/other/timer_notipod.dart';
import '../../../shared/auth_button_grey.dart';
import '../../../shared/auth_frame.dart';
import '../../../shared/auth_header_text.dart';
import '../../../shared/open_my_email_button.dart';
import '../../sign_in_up/provider/auth_model_notipod.dart';
import '../notifier/email_verification_state.dart';
import '../notifier/email_verification_union.dart';
import '../provider/email_verification_notipod.dart';
import 'components/email_verification_text.dart';
import 'components/email_verification_text_field.dart';
import 'components/resend_button.dart';
import 'components/resend_in_text.dart';

class EmailVerification extends StatefulHookWidget {
  const EmailVerification({
    Key? key,
    this.code,
  }) : super(key: key);

  final String? code;

  @override
  _EmailVerificationState createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  @override
  void initState() {
    context.read(emailVerificationNotipod.notifier).updateCode(widget.code);
    super.initState();
  }

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
              const SpaceH20(),
              const EmailVerificationText(
                text: 'Check your email on this device to verify your account',
              ),
              const SpaceH50(),
              if (state.union is Loading)
                Loader()
              else ...[
                EmailVerificationText(
                  text: 'Sent to ${authModel.email}',
                ),
                const SpaceH5(),
                if (timer != 0)
                  ResendInText(seconds: timer)
                else ...[
                  const SpaceH5(),
                  ResendButton(
                    onTap: () async {
                      await notifier.sendCode();

                      if (state.union is Input) {
                        timerN.refreshTimer();
                      }
                    },
                  ),
                ],
                const SpaceH50(),
                EmailVerificationTextField(
                  initialValue: state.code,
                  onChanged: (value) => notifier.updateCode(value),
                ),
                const Spacer(),
                const OpenMyEmailButton(),
                const SpaceH15(),
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
