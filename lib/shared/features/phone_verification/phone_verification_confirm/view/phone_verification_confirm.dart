import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../auth/shared/components/clickable_link_text/clickable_link_text.dart';
import '../../../../components/loaders/scaffold_loader.dart';
import '../../../../components/pin_code_field.dart';
import '../../../../components/texts/resend_in_text.dart';
import '../../../../components/texts/resend_rich_text.dart';
import '../../../../components/texts/verification_description_text.dart';
import '../../../../helpers/navigator_push.dart';
import '../../../../helpers/show_plain_snackbar.dart';
import '../../../../notifiers/timer_notifier/timer_notipod.dart';
import '../../../../services/remote_config_service/remote_config_values.dart';
import '../notifier/phone_verification_confirm_notipod.dart';
import '../notifier/phone_verification_confirm_state.dart';
import '../notifier/phone_verification_confirm_union.dart';

class PhoneVerificationConfirm extends HookWidget {
  const PhoneVerificationConfirm({
    Key? key,
    required this.onVerified,
  }) : super(key: key);

  final Function() onVerified;

  static void push(BuildContext context, Function() onVerified) {
    navigatorPush(
      context,
      PhoneVerificationConfirm(
        onVerified: onVerified,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final phone = useProvider(phoneVerificationConfirmNotipod(onVerified));
    final phoneN = useProvider(
      phoneVerificationConfirmNotipod(onVerified).notifier,
    );
    // TODO add phoneVerificationCountdown
    final timer = useProvider(timerNotipod(emailResendCountdown));
    final timerN = useProvider(timerNotipod(emailResendCountdown).notifier);
    final pinError = useValueNotifier(StandardFieldErrorNotifier());

    return ProviderListener<PhoneVerificationConfirmState>(
      provider: phoneVerificationConfirmNotipod(onVerified),
      onChange: (context, state) {
        state.union.maybeWhen(
          error: (error) {
            showPlainSnackbar(context, error);
            phoneN.resetError();
            Navigator.of(context).pop();
          },
          orElse: () {},
        );
      },
      child: Stack(
        children: [
          SPageFrame(
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
                    text: 'Enter the SMS code we have sent to your \nphone ',
                    boldText: phone.phoneNumber,
                  ),
                  const SpaceH18(),
                  ClickableLinkText(
                    text: 'Change number',
                    onTap: () => Navigator.pop(context),
                  ),
                  const SpaceH80(),
                  PinCodeField(
                    length: 4,
                    controller: phone.controller,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    onCompleted: (_) async {
                      await phoneN.verifyCode();
                    },
                    pinError: pinError.value,
                  ),
                  if (timer != 0 && !phone.showResend)
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
          ),
          if (phone.union is Loading) const ScaffoldLoader(),
        ],
      ),
    );
  }
}
