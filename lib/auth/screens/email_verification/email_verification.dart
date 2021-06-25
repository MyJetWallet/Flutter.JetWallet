import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/components/spacers.dart';
import '../../../shared/helpers/navigator_push.dart';
import '../../../shared/providers/other/timer_notipod.dart';
import '../../shared/auth_button_grey.dart';
import '../../shared/auth_frame.dart';
import '../../shared/auth_header_text.dart';
import '../../shared/open_my_email_button.dart';
import '../email_verification_success/email_verification_success.dart';
import 'components/email_verification_text.dart';
import 'components/email_verification_text_field.dart';
import 'components/resend_button.dart';
import 'components/resend_in_text.dart';

class EmailVerification extends HookWidget {
  const EmailVerification({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final timer = useProvider(timerNotipod(5));

    return Scaffold(
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
            const EmailVerificationText(
              text: 'Sent to danilkin2ua@gmail.com',
            ),
            const SpaceH5(),
            if (timer != 0)
              ResendInText(seconds: timer)
            else ...[
              const SpaceH5(),
              ResendButton(
                // TODO Refresh for StateNotifierProvider is currently broken
                // Find workaround (will be fixed in 1.0.0 - stable)
                onTap: () => context.refresh(timerNotipod(5)),
              ),
            ],
            const SpaceH50(),
            const EmailVerificationTextField(),
            const Spacer(),
            const OpenMyEmailButton(),
            const SpaceH15(),
            AuthButtonGrey(
              text: 'Continue',
              onTap: () {
                navigatorPush(context, const EmailVerificationSuccess());
              },
            ),
          ],
        ),
      ),
    );
  }
}
