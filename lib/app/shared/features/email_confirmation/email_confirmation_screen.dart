import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:jetwallet/app/shared/features/email_confirmation/notifier/email_confirmation_notipod.dart';
import 'package:jetwallet/app/shared/features/email_confirmation/notifier/email_confirmation_state.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../auth/shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../../../../shared/components/pin_code_field.dart';
import '../../../../shared/helpers/navigate_to_router.dart';
import '../../../../shared/helpers/open_email_app.dart';
import '../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../../shared/services/remote_config_service/remote_config_values.dart';

class EmailConfirmationScreen extends StatefulHookWidget {
  const EmailConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<EmailConfirmationScreen> createState() =>
      _EmailConfirmationScreenState();
}

class _EmailConfirmationScreenState extends State<EmailConfirmationScreen> {
  final focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final timer = useProvider(timerNotipod(emailResendCountdown));
    final timerN = useProvider(timerNotipod(emailResendCountdown).notifier);
    final confirmation = useProvider(emailConfirmationNotipod);
    final confirmationN = useProvider(emailConfirmationNotipod.notifier);
    final authInfo = useProvider(authInfoNotipod);
    final showResend = useState(authInfo.showResendButton);
    final pinError = useValueNotifier(StandardFieldErrorNotifier());
    final loader = useValueNotifier(StackLoaderNotifier());

    focusNode.addListener(() {
      if (focusNode.hasFocus &&
          confirmation.controller.value.text.length ==
              emailVerificationCodeLength &&
          pinError.value.value) {
        confirmation.controller.clear();
      }
    });

    return ProviderListener<EmailConfirmationState>(
      provider: emailConfirmationNotipod,
      onChange: (context, state) {
        state.union.maybeWhen(
          error: (Object? error) {
            loader.value.finishLoading();
            pinError.value.enableError();
          },
          orElse: () {},
        );
      },
      child: SPageFrameWithPadding(
        header: SBigHeader(
          title: intl.emailVerification_emailVerification,
          onBackButtonTap: () => {},
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SpaceH7(),
                  Text(
                    intl.emailConfirmation_text,
                    maxLines: 3,
                    style: sBodyText1Style.copyWith(
                      color: colors.grey1,
                    ),
                  ),
                  Text(
                    authInfo.email,
                    style: sBodyText1Style,
                  ),
                  const SpaceH17(),
                  SClickableLinkText(
                    text: intl.emailVerification_openEmail,
                    onTap: () => openEmailApp(context),
                  ),
                  const SpaceH40(),
                  GestureDetector(
                    onLongPress: () => confirmationN.pasteCode(),
                    onDoubleTap: () => confirmationN.pasteCode(),
                    onTap: () {
                      focusNode.unfocus();

                      Future.delayed(const Duration(microseconds: 100), () {
                        if (!focusNode.hasFocus) {
                          focusNode.requestFocus();
                        }
                      });
                    },
                    // AbsorbPointer needed to avoid TextField glitch onTap
                    // when it's focused
                    child: AbsorbPointer(
                      child: PinCodeField(
                        focusNode: focusNode,
                        controller: confirmation.controller,
                        length: emailVerificationCodeLength,
                        onCompleted: (_) {
                          loader.value.startLoading();
                          confirmationN.verifyCode();
                        },
                        autoFocus: true,
                        onChanged: (_) {
                          pinError.value.disableError();
                        },
                        pinError: pinError.value,
                      ),
                    ),
                  ),
                  const SpaceH7(),
                  SResendButton(
                    active: !confirmation.isResending,
                    timer: showResend.value ? 0 : timer,
                    onTap: () {
                      confirmation.controller.clear();

                      confirmationN.resendCode(
                        onSuccess: () {
                          timerN.refreshTimer();
                          showResend.value = false;
                        },
                      );
                    },
                    text1: intl.emailVerification_youCanResendIn,
                    text2: intl.emailVerification_seconds,
                    text3: intl.emailVerification_didntReceiveTheCode,
                    textResend: intl.emailVerification_resend,
                  ),
                  const Spacer(),
                  SSecondaryButton1(
                    active: true,
                    name: intl.emailConfirmation_cancel,
                    onTap: () => navigateToRouter(context.read),
                  ),
                  const SpaceH24(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
