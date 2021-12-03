import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/components/loaders/loader.dart';
import '../../../../shared/components/pin_code_field.dart';
import '../../../../shared/components/texts/resend_in_text.dart';
import '../../../../shared/helpers/open_email_app.dart';
import '../../../../shared/notifiers/logout_notifier/logout_notipod.dart';
import '../../../../shared/notifiers/logout_notifier/logout_union.dart' as lu;
import '../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../notifier/email_verification_notipod.dart';
import '../notifier/email_verification_state.dart';
import '../notifier/email_verification_union.dart';

class EmailVerification extends HookWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final timer = useProvider(timerNotipod(emailResendCountdown));
    final timerN = useProvider(timerNotipod(emailResendCountdown).notifier);
    final logout = useProvider(logoutNotipod);
    final logoutN = useProvider(logoutNotipod.notifier);
    final verification = useProvider(emailVerificationNotipod);
    final verificationN = useProvider(emailVerificationNotipod.notifier);
    final authInfo = useProvider(authInfoNotipod);
    final showResend = useState(authInfo.showResendButton);
    final notificationQueueN = useProvider(sNotificationQueueNotipod.notifier);
    final pinError = useValueNotifier(StandardFieldErrorNotifier());

    return ProviderListener<EmailVerificationState>(
      provider: emailVerificationNotipod,
      onChange: (context, state) {
        state.union.maybeWhen(
          error: (Object? error) {
            pinError.value.enableError();
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
                sShowErrorNotification(
                  notificationQueueN,
                  '$error',
                );
              }
            },
            loading: () {},
          );
        },
        child: logout.when(
          result: (_, __) {
            return SPageFrameWithPadding(
              header: SBigHeader(
                title: 'Email verification',
                onBackButtonTap: () => logoutN.logout(),
              ),
              resizeToAvoidBottomInset: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceH7(),
                  Text(
                    'Enter the code we have sent to your email',
                    style: sBodyText1Style.copyWith(color: colors.grey1),
                  ),
                  Text(
                    authInfo.email,
                    style: sBodyText1Style,
                  ),
                  const SpaceH17(),
                  SClickableLinkText(
                    text: 'Open Email App',
                    onTap: () => openEmailApp(context),
                  ),
                  const SpaceH49(),
                  PinCodeField(
                    controller: verification.controller,
                    length: emailVerificationCodeLength,
                    onCompleted: (_) => verificationN.verifyCode(),
                    autoFocus: true,
                    pinError: pinError.value,
                  ),
                  const SpaceH7(),
                  if (timer != 0 && !showResend.value)
                    ResendInText(text: 'You can resend in $timer seconds')
                  else ...[
                    const ResendInText(text: "Didn't receive the code?"),
                    const SpaceH24(),
                    STextButton1(
                      active: true,
                      name: 'Resend',
                      onTap: () async {
                        await verificationN.sendCode();

                        if (verification.union is Input) {
                          timerN.refreshTimer();
                          showResend.value = false;
                        }
                      },
                    ),
                  ]
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
