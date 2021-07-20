import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/components/loader.dart';
import '../../../../shared/components/spacers.dart';
import '../../../../shared/helpers/show_plain_snackbar.dart';
import '../../../../shared/notifiers/logout_notifier/logout_notipod.dart';
import '../../../../shared/notifiers/logout_notifier/logout_union.dart' as lu;
import '../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../shared/components/auth_frame/auth_frame.dart';
import '../../../shared/components/buttons/auth_button_solid.dart';
import '../notifier/email_verification_notipod.dart';
import '../notifier/email_verification_state.dart';
import '../notifier/email_verification_union.dart';
import 'components/email_resend_in_text.dart';
import 'components/email_resend_rich_text.dart';
import 'components/email_verification_description.dart';
import 'components/email_verification_pin_code.dart';
import 'components/open_email_app_button.dart';

class EmailVerification extends HookWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final timer = useProvider(timerNotipod(5));
    final timerN = useProvider(timerNotipod(5).notifier);
    final logout = useProvider(logoutNotipod);
    final logoutN = useProvider(logoutNotipod.notifier);
    final verification = useProvider(emailVerificationNotipod);
    final verificationN = useProvider(emailVerificationNotipod.notifier);

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
            return AuthFrame(
              header: intl.emailVerification,
              onBackButton: () => logoutN.logout(),
              resizeToAvoidBottomInset: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceH15(),
                  const EmailVerificationDescription(),
                  const SpaceH10(),
                  const OpenEmailAppButton(),
                  const SpaceH120(),
                  EmailVerificationPinCode(
                    controller: verification.controller,
                    onCompleted: (_) => verificationN.verifyCode(),
                  ),
                  const SpaceH10(),
                  if (timer != 0)
                    EmailResendInText(seconds: timer)
                  else ...[
                    EmailResendRichText(
                      onTap: () async {
                        await verificationN.sendCode();

                        if (verification.union is Input) {
                          timerN.refreshTimer();
                        }
                      },
                    ),
                  ],
                  const SpaceH40(),
                  const Spacer(),
                  if (verification.union is Loading)
                    const Loader()
                  else
                    AuthButtonSolid(
                      name: intl.confirm,
                      onTap: () => verificationN.verifyCode(),
                    ),
                ],
              ),
            );
          },
          loading: () => const Loader(),
        ),
      ),
    );
  }
}
