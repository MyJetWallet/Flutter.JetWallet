import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/components/pin_code_field.dart';
import '../../../../shared/helpers/get_args.dart';
import '../../../../shared/helpers/open_email_app.dart';
import '../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../reset_password/view/reset_password.dart';
import '../notifier/confirm_password_reset/confirm_password_reset_notipod.dart';

late String email;

@immutable
class ConfirmPasswordResetArgs {
  const ConfirmPasswordResetArgs({
    required this.email,
  });

  final String email;
}

class ConfirmPasswordReset extends HookWidget {
  const ConfirmPasswordReset({Key? key}) : super(key: key);

  static const routeName = '/confirm_password_reset';

  static Future push({
    required BuildContext context,
    required ConfirmPasswordResetArgs args,
  }) {
    return Navigator.pushNamed(
      context,
      routeName,
      arguments: args,
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = getArgs(context) as ConfirmPasswordResetArgs;
    email = args.email;

    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final state = useProvider(confirmPasswordResetNotipod(args.email));
    final notifier =
        useProvider(confirmPasswordResetNotipod(args.email).notifier);
    final timer = useProvider(timerNotipod(emailResendCountdown));
    final timerN = useProvider(timerNotipod(emailResendCountdown).notifier);
    final pinError = useValueNotifier(StandardFieldErrorNotifier());
    final focusNode = useFocusNode();

    focusNode.addListener(() {
      if (focusNode.hasFocus &&
          state.controller.value.text.length == 4 &&
          pinError.value.value) {
        state.controller.clear();
      }
    });

    return SPageFrameWithPadding(
      header: SBigHeader(
        title: intl.confirmPassword_checkYourEmail,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH7(),
          Text(
            intl.confirmPassword_recoveryEmail,
            style: sBodyText1Style.copyWith(
              color: colors.grey1,
            ),
            maxLines: 2,
          ),
          Text(
            '${args.email} \n',
            style: sBodyText1Style,
            maxLines: 2,
          ),
          Text(
            intl.confirmPassword_seeThePasswordRecovery,
            style: sBodyText1Style.copyWith(
              color: colors.grey1,
            ),
            maxLines: 2,
          ),
          const SpaceH17(),
          SClickableLinkText(
            text: intl.emailVerification_openEmail,
            onTap: () => openEmailApp(context),
          ),
          const SpaceH29(),
          GestureDetector(
            onLongPress: () => notifier.pasteCode(),
            onDoubleTap: () => notifier.pasteCode(),
            onTap: () {
              if (!focusNode.hasFocus) {
                focusNode.requestFocus();
              }
            },
            child: AbsorbPointer(
              child: PinCodeField(
                focusNode: focusNode,
                controller: state.controller,
                length: emailVerificationCodeLength,
                onCompleted: (_) {
                  ResetPassword.push(
                    context: context,
                    args: ResetPasswordArgs(
                      email: email,
                      code: state.controller.text,
                    ),
                  );
                  state.controller.clear();
                },
                autoFocus: true,
                onChanged: (_) {
                  pinError.value.disableError();
                },
                pinError: pinError.value,
              ),
            ),
          ),
          SResendButton(
            active: !state.isResending,
            timer: timer,
            onTap: () {
              state.controller.clear();

              notifier.resendCode(
                onSuccess: () {
                  timerN.refreshTimer();
                },
              );
            },
            text1: intl.confirmPasswordReset_youCanResendIn,
            text2: intl.confirmPasswordReset_seconds,
            text3: intl.confirmPasswordReset_didntReceiveTheCode,
            textResend: intl.confirmPasswordReset_resend,
          ),
        ],
      ),
    );
  }
}
