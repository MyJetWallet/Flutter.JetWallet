import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/two_fa_phone/model/two_fa_phone_trigger_union.dart';
import 'package:jetwallet/features/two_fa_phone/model/two_fa_phone_union.dart';
import 'package:jetwallet/features/two_fa_phone/store/two_fa_phone_store.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:jetwallet/widgets/loaders/loader.dart';
import 'package:jetwallet/widgets/pin_code_field.dart';
import 'package:jetwallet/widgets/texts/resend_in_text.dart';
import 'package:jetwallet/widgets/texts/verification_description_text.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

@RoutePage(name: 'TwoFaPhoneRouter')
class TwoFaPhone extends StatelessWidget {
  const TwoFaPhone({
    super.key,
    required this.trigger,
  });

  final TwoFaPhoneTriggerUnion trigger;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TimerStore>(
          create: (_) => TimerStore(emailResendCountdown),
          dispose: (context, store) => store.dispose(),
        ),
        Provider<TwoFaPhoneStore>(
          create: (_) => TwoFaPhoneStore(trigger),
          dispose: (context, store) => store.dispose(),
        ),
      ],
      builder: (context, child) {
        return _TwoFaPhoneBody(
          trigger: trigger,
        );
      },
    );
  }
}

class _TwoFaPhoneBody extends StatelessObserverWidget {
  const _TwoFaPhoneBody({
    super.key,
    required this.trigger,
  });

  final TwoFaPhoneTriggerUnion trigger;

  @override
  Widget build(BuildContext context) {
    final twoFa = TwoFaPhoneStore.of(context);

    // TODO add twoFaPhoneResendCountdown to remote config
    final timer = TimerStore.of(context);

    final logout = getIt.get<LogoutService>();

    logout.union.when(
      result: (error, st) {
        if (error != null) {
          sNotification.showError('$error', id: 1);
        }
      },
      loading: () {},
    );

    twoFa.union.maybeWhen(
      error: (error) {
        twoFa.loader.finishLoading();
        twoFa.pinError.enableError();
        twoFa.resetError();
      },
      orElse: () {},
    );

    return logout.union.when(
      result: (_, __) {
        return SPageFrameWithPadding(
          loaderText: intl.register_pleaseWait,
          loading: twoFa.loader,
          header: SBigHeader(
            title: intl.twoFaPhone_phoneConfirmation,
            onBackButtonTap: () => trigger.when(
              startup: () => logout.logout(
                'TWO FA, logout',
                withLoading: false,
                callbackAfterSend: () {},
              ),
              security: (_) => sRouter.pop(),
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
                onLongPress: () => twoFa.pasteCode(),
                onDoubleTap: () => twoFa.pasteCode(),
                onTap: () {
                  twoFa.focusNode.unfocus();

                  Future.delayed(
                    const Duration(microseconds: 100),
                    () {
                      if (!twoFa.focusNode.hasFocus) {
                        twoFa.focusNode.requestFocus();
                      }
                    },
                  );
                },
                child: AbsorbPointer(
                  child: PinCodeField(
                    focusNode: twoFa.focusNode,
                    length: 4,
                    autoFocus: true,
                    controller: twoFa.controller,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    onCompleted: (_) async {
                      twoFa.loader.startLoading();
                      await twoFa.verifyCode();
                    },
                    onChanged: (_) {
                      twoFa.pinError.disableError();
                    },
                    pinError: twoFa.pinError,
                  ),
                ),
              ),
              const SpaceH7(),
              if (timer.time > 0 && !twoFa.showResend)
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
                    await twoFa.sendCode();

                    if (twoFa.union is Input) {
                      timer.refreshTimer();
                      twoFa.updateShowResend(
                        sResend: false,
                      );
                    }
                  },
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const Loader(),
    );
  }
}
