import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

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

class PhoneVerificationConfirm extends HookWidget {
  const PhoneVerificationConfirm({
    Key? key,
    required this.onVerified,
    required this.isChangeTextAlert,
  }) : super(key: key);

  final Function() onVerified;
  final bool isChangeTextAlert;

  static void push({
    required BuildContext context,
    required Function() onVerified,
    required bool isChangeTextAlert,
  }) {
    navigatorPush(
      context,
      PhoneVerificationConfirm(
        onVerified: onVerified,
        isChangeTextAlert: isChangeTextAlert,
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
    final colors = useProvider(sColorPod);
    final loading = useValueNotifier(StackLoaderNotifier());

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
            loading: loading.value,
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
                  if (isChangeTextAlert) ...[
                    RichText(
                      text: TextSpan(
                        style: sBodyText1Style.copyWith(
                          color: colors.grey1,
                        ),
                        children: [
                          const TextSpan(
                            text: 'If you don’t have access to this number, '
                                ' please contact ',
                          ),
                          TextSpan(
                            text: 'support',
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
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    onCompleted: (_) async {
                      loading.value.startLoading();
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
        ],
      ),
    );
  }
}
