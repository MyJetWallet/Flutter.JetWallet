import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../app/shared/features/phone_verification/view/phone_verification.dart';
import '../../../components/loaders/loader.dart';
import '../../../components/pin_code_field.dart';
import '../../../components/texts/resend_in_text.dart';
import '../../../components/texts/verification_description_text.dart';
import '../../../helpers/navigator_push.dart';
import '../../../helpers/navigator_push_replacement.dart';
import '../../../notifiers/logout_notifier/logout_notipod.dart';
import '../../../notifiers/logout_notifier/logout_union.dart' as lu;
import '../../../notifiers/timer_notifier/timer_notipod.dart';
import '../../../providers/service_providers.dart';
import '../../../services/remote_config_service/remote_config_values.dart';
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

  static void push(BuildContext context, TwoFaPhoneTriggerUnion trigger) {
    navigatorPush(context, TwoFaPhone(trigger: trigger));
  }

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
    final intl = useProvider(intlPod);
    final twoFa = useProvider(twoFaPhoneNotipod(trigger));
    final twoFaN = useProvider(twoFaPhoneNotipod(trigger).notifier);
    // TODO add twoFaPhoneResendCountdown to remote config
    final timer = useProvider(timerNotipod(emailResendCountdown));
    final timerN = useProvider(timerNotipod(emailResendCountdown).notifier);
    final logout = useProvider(logoutNotipod);
    final logoutN = useProvider(logoutNotipod.notifier);
    final pinError = useValueNotifier(StandardFieldErrorNotifier());
    final notificationN = useProvider(sNotificationNotipod.notifier);
    final loader = useValueNotifier(StackLoaderNotifier());
    final focusNode = useFocusNode();

    focusNode.addListener(() {
      if (focusNode.hasFocus &&
          twoFa.controller.value.text.length == codeLength &&
          pinError.value.value) {
        twoFa.controller.clear();
      }
    });

    return ProviderListener<lu.LogoutUnion>(
      provider: logoutNotipod,
      onChange: (context, union) {
        union.when(
          result: (error, st) {
            if (error != null) {
              notificationN.showError('$error', id: 1);
            }
          },
          loading: () {},
        );
      },
      child: ProviderListener<TwoFaPhoneState>(
        provider: twoFaPhoneNotipod(trigger),
        onChange: (context, state) {
          state.union.maybeWhen(
            error: (error) {
              loader.value.finishLoading();
              pinError.value.enableError();
              twoFaN.resetError();
            },
            orElse: () {},
          );
        },
        child: logout.when(
          result: (_, __) {
            return SPageFrameWithPadding(
              loading: loader.value,
              header: SBigHeader(
                title: intl.twoFaPhone_phoneConfirmation,
                onBackButtonTap: () => trigger.when(
                  startup: () => logoutN.logout(),
                  security: (_) => Navigator.pop(context),
                ),
              ),
              child: Column(
                children: [
                  const SpaceH10(),
                  VerificationDescriptionText(
                    text: '${intl.twoFaPhone_enterSmsCode} ',
                    boldText: twoFa.phoneNumber,
                  ),
                  const SpaceH60(),
                  GestureDetector(
                    onLongPress: () => twoFaN.pasteCode(),
                    onDoubleTap: () => twoFaN.pasteCode(),
                    onTap: () {
                      focusNode.unfocus();

                      Future.delayed(const Duration(microseconds: 100), () {
                        if (!focusNode.hasFocus) {
                          focusNode.requestFocus();
                        }
                      });
                    },
                    child: AbsorbPointer(
                      child: PinCodeField(
                        focusNode: focusNode,
                        length: 4,
                        autoFocus: true,
                        controller: twoFa.controller,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        onCompleted: (_) async {
                          loader.value.startLoading();
                          await twoFaN.verifyCode();
                        },
                        onChanged: (_) {
                          pinError.value.disableError();
                        },
                        pinError: pinError.value,
                      ),
                    ),
                  ),
                  const SpaceH7(),
                  if (timer > 0 && !twoFa.showResend)
                    ResendInText(
                      text: '${intl.twoFaPhone_youCanResendIn} $timer'
                          ' ${intl.twoFaPhone_seconds}',
                    )
                  else ...[
                    ResendInText(
                      text: '${intl.twoFaPhone_didntReceiveTheCode}?',
                    ),
                    const SpaceH24(),
                    STextButton1(
                      active: true,
                      name: intl.twoFaPhone_resend,
                      onTap: () async {
                        await twoFaN.sendCode();

                        if (twoFa.union is Input) {
                          timerN.refreshTimer();
                          twoFaN.updateShowResend(
                            showResend: false,
                          );
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
