import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../components/loaders/scaffold_loader.dart';
import '../../../../components/page_frame/page_frame.dart';
import '../../../../components/pin_code_field.dart';
import '../../../../components/spacers.dart';
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
import 'components/change_number_button.dart';

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

    return ProviderListener<PhoneVerificationConfirmState>(
      provider: phoneVerificationConfirmNotipod(onVerified),
      onChange: (context, state) {
        state.union.maybeWhen(
          error: (error) {
            showPlainSnackbar(context, error);
            phoneN.resetError();
          },
          orElse: () {},
        );
      },
      child: Stack(
        children: [
          PageFrame(
            header: 'Phone Confirmation',
            onBackButton: () => Navigator.pop(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceH10(),
                VerificationDescriptionText(
                  text: 'Enter the SMS code we have sent to your phone ',
                  boldText: phone.phoneNumber,
                ),
                const SpaceH10(),
                const ChangeNumberButton(),
                const SpaceH120(),
                PinCodeField(
                  length: 4,
                  controller: phone.controller,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  onCompleted: (_) async {
                    await phoneN.verifyCode();
                  },
                ),
                if (timer != 0 && !phone.showResend)
                  ResendInText(seconds: timer)
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
          if (phone.union is Loading) const ScaffoldLoader(),
        ],
      ),
    );
  }
}
