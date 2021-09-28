import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../components/loader.dart';
import '../../../../components/page_frame/page_frame.dart';
import '../../../../components/pin_code_field.dart';
import '../../../../components/spacers.dart';
import '../../../../components/texts/resend_in_text.dart';
import '../../../../components/texts/resend_rich_text.dart';
import '../../../../components/texts/verification_description_text.dart';
import '../../../../helpers/navigator_push_replacement.dart';
import '../../../../helpers/show_plain_snackbar.dart';
import '../../../../notifiers/logout_notifier/logout_notipod.dart';
import '../../../../notifiers/logout_notifier/logout_union.dart' as lu;
import '../../../../notifiers/timer_notifier/timer_notipod.dart';
import '../../../../services/remote_config_service/remote_config_values.dart';
import '../model/two_fa_phone_trigger_union.dart';
import '../notifier/two_fa_phone_notipod.dart';
import '../notifier/two_fa_phone_state.dart';
import '../notifier/two_fa_phone_union.dart';

class TwoFaPhone extends HookWidget {
  const TwoFaPhone({
    Key? key,
    required this.trigger,
  }) : super(key: key);

  final TwoFaPhoneTriggerUnion trigger;

  static void pushReplacement(
    BuildContext context,
    TwoFaPhoneTriggerUnion trigger,
  ) {
    navigatorPushReplacement(
      context,
      TwoFaPhone(
        trigger: trigger,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final twoFa = useProvider(twoFaPhoneNotipod(trigger));
    final twoFaN = useProvider(twoFaPhoneNotipod(trigger).notifier);
    // TODO add twoFaPhoneResendCountdown to remote config
    final timer = useProvider(timerNotipod(emailResendCountdown));
    final timerN = useProvider(timerNotipod(emailResendCountdown).notifier);
    final logout = useProvider(logoutNotipod);
    final logoutN = useProvider(logoutNotipod.notifier);

    Function()? onBackButton;

    trigger.when(
      login: () {
        onBackButton = () => logoutN.logout();
      },
      security: () {
        onBackButton = () => Navigator.pop(context);
      },
    );

    return ProviderListener<lu.LogoutUnion>(
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
      child: ProviderListener<TwoFaPhoneState>(
        provider: twoFaPhoneNotipod(trigger),
        onChange: (context, state) {
          state.union.maybeWhen(
            error: (Object? error) {
              showPlainSnackbar(context, error.toString());
            },
            orElse: () {},
          );
        },
        child: logout.when(
          result: (_, __) {
            return PageFrame(
              header: 'Phone Confirmation',
              onBackButton: onBackButton,
              child: Column(
                children: [
                  const SpaceH10(),
                  const VerificationDescriptionText(
                    text: 'Enter the SMS code we have sent to your phone ',
                    boldText: '+380503858085',
                  ),
                  const SpaceH120(),
                  if (twoFa.union is Loading)
                    const Loader()
                  else ...[
                    PinCodeField(
                      length: 4,
                      autoFocus: true,
                      controller: twoFa.controller,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      onCompleted: (_) async {
                        await twoFaN.verifyCode();
                      },
                    ),
                    if (timer != 0 && !twoFa.showResend)
                      ResendInText(seconds: timer)
                    else ...[
                      ResendRichText(
                        onTap: () async {
                          await twoFaN.sendCode();

                          if (twoFa.union is Input) {
                            timerN.refreshTimer();
                            twoFaN.updateShowResend(
                              value: false,
                            );
                          }
                        },
                      ),
                    ],
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
