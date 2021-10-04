import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../shared/components/buttons/app_button_solid.dart';
import '../../../../shared/components/loader.dart';
import '../../../../shared/components/page_frame/page_frame.dart';
import '../../../../shared/components/pin_code_field.dart';
import '../../../../shared/components/spacers.dart';
import '../../../../shared/components/texts/resend_in_text.dart';
import '../../../../shared/components/texts/resend_rich_text.dart';
import '../../../../shared/components/texts/verification_description_text.dart';
import '../../../../shared/helpers/show_plain_snackbar.dart';
import '../../../../shared/notifiers/logout_notifier/logout_notipod.dart';
import '../../../../shared/notifiers/logout_notifier/logout_union.dart' as lu;
import '../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../notifier/email_verification_notipod.dart';
import '../notifier/email_verification_state.dart';
import '../notifier/email_verification_union.dart';
import 'components/open_email_app_button.dart';

class EmailVerification extends HookWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final timer = useProvider(timerNotipod(emailResendCountdown));
    final timerN = useProvider(timerNotipod(emailResendCountdown).notifier);
    final logout = useProvider(logoutNotipod);
    final logoutN = useProvider(logoutNotipod.notifier);
    final verification = useProvider(emailVerificationNotipod);
    final verificationN = useProvider(emailVerificationNotipod.notifier);
    final authInfo = useProvider(authInfoNotipod);
    final showResend = useState(authInfo.showResendButton);

    return ProviderListener<EmailVerificationState>(
      provider: emailVerificationNotipod,
      onChange: (context, state) {
        state.union.maybeWhen(
          error: (Object? error) {
            showPlainSnackbar(context, 'Error occurred');
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
            return PageFrame(
              header: intl.emailVerification,
              onBackButton: () => logoutN.logout(),
              resizeToAvoidBottomInset: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceH15(),
                  VerificationDescriptionText(
                    text: '${intl.enterTheCodeWeHaveSentYouToYourEmail} ',
                    boldText: authInfo.email,
                  ),
                  const SpaceH10(),
                  const OpenEmailAppButton(),
                  const SpaceH120(),
                  PinCodeField(
                    controller: verification.controller,
                    length: emailVerificationCodeLength,
                    onCompleted: (_) => verificationN.verifyCode(),
                  ),
                  const SpaceH10(),
                  if (timer != 0 && !showResend.value)
                    ResendInText(seconds: timer)
                  else ...[
                    ResendRichText(
                      onTap: () async {
                        await verificationN.sendCode();

                        if (verification.union is Input) {
                          timerN.refreshTimer();
                          showResend.value = false;
                        }
                      },
                    ),
                  ],
                  const SpaceH40(),
                  const Spacer(),
                  if (verification.union is Loading)
                    const Loader()
                  else
                    AppButtonSolid(
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
