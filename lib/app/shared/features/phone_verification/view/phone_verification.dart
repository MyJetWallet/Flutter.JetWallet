import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/components/pin_code_field.dart';
import '../../../../../shared/components/texts/resend_in_text.dart';
import '../../../../../shared/components/texts/resend_rich_text.dart';
import '../../../../../shared/components/texts/verification_description_text.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../screens/account/components/crisp.dart';
import '../notifier/phone_verification_notipod.dart';

class PhoneVerificationArgs {
  PhoneVerificationArgs({
    this.showChangeTextAlert = false,
    this.sendCodeOnInitState = true,
    required this.phoneNumber,
    required this.onVerified,
  });

  final bool sendCodeOnInitState;
  final bool showChangeTextAlert;
  final String phoneNumber;
  final void Function() onVerified;
}

/// Called in 2 cases:
/// 1. when we need to verfiy user before change number flow
/// 2. when we need to verify a new number from change number flow
class PhoneVerification extends HookWidget {
  const PhoneVerification({
    Key? key,
    required this.args,
  }) : super(key: key);

  final PhoneVerificationArgs args;

  static void push({
    required BuildContext context,
    required PhoneVerificationArgs args,
  }) {
    navigatorPush(
      context,
      PhoneVerification(
        args: args,
      ),
    );
  }

  static void pushReplacement({
    required BuildContext context,
    required PhoneVerificationArgs args,
  }) {
    navigatorPushReplacement(
      context,
      PhoneVerification(
        args: args,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phone = useProvider(phoneVerificationNotipod(args));
    final phoneN = useProvider(phoneVerificationNotipod(args).notifier);
    // TODO add phoneVerificationCountdown
    final timer = useProvider(timerNotipod(emailResendCountdown));
    final timerN = useProvider(timerNotipod(emailResendCountdown).notifier);
    final colors = useProvider(sColorPod);

    return SPageFrame(
      loading: phone.loader,
      header: SPaddingH24(
        child: SSmallHeader(
          title: 'Phone confirmation',
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: SPaddingH24(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SpaceH10(),
            VerificationDescriptionText(
              text: 'Enter the SMS code we have sent to your phone ',
              boldText: phone.phoneNumber,
            ),
            const SpaceH18(),
            if (args.showChangeTextAlert) ...[
              RichText(
                text: TextSpan(
                  style: sBodyText1Style.copyWith(
                    color: colors.grey1,
                  ),
                  children: [
                    const TextSpan(
                      text: "If you don't have access to this number, "
                          ' please contact ',
                    ),
                    TextSpan(
                      text: 'support',
                      recognizer: TapGestureRecognizer()..onTap = () {
                        Crisp.push(context);
                      },
                      style: sBodyText1Style.copyWith(
                        color: colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ] else
              SClickableLinkText(
                text: 'Change number',
                onTap: () => Navigator.pop(context),
              ),
            const SpaceH18(),
            PinCodeField(
              length: 4,
              controller: phone.controller,
              autoFocus: true,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              onCompleted: (_) => phoneN.verifyCode(),
              pinError: phone.pinFieldError!,
            ),
            /// TODO update legacy resend
            if (timer > 0 && !phone.showResend)
              ResendInText(text: 'You can resend in $timer seconds')
            else ...[
              ResendRichText(
                onTap: () async {
                  await phoneN.sendCode();
                  timerN.refreshTimer();
                  phoneN.updateShowResend(
                    showResend: false,
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
