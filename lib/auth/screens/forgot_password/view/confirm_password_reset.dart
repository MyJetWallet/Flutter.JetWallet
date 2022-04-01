import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../shared/components/pin_code_field.dart';
import '../../../../shared/helpers/get_args.dart';
import '../../../../shared/helpers/open_email_app.dart';
import '../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
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
      header: const SBigHeader(
        title: 'Check your Email',
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH7(),
          Text(
            'Recovery email with reset password instruction has been '
            'sent to',
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
            "If you don't see the password recovery email in your inbox, "
            'check your spam folder',
            style: sBodyText1Style.copyWith(
              color: colors.grey1,
            ),
            maxLines: 2,
          ),
          const SpaceH17(),
          SClickableLinkText(
            text: 'Open Email App',
            onTap: () => openEmailApp(context),
          ),
          const SpaceH29(),
          PinCodeField(
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
          ),
        ],
      ),
    );
  }
}
