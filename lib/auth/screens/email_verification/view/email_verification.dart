import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:universal_io/io.dart';

import '../../../../shared/components/pin_code_field.dart';
import '../../../../shared/components/texts/resend_in_text.dart';
import '../../../../shared/helpers/analytics.dart';
import '../../../../shared/helpers/open_email_app.dart';
import '../../../../shared/notifiers/timer_notifier/timer_notipod.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../shared/notifiers/auth_info_notifier/auth_info_notipod.dart';
import '../notifier/email_verification_notipod.dart';
import '../notifier/email_verification_state.dart';

class EmailVerification extends StatefulHookWidget {
  const EmailVerification({Key? key}) : super(key: key);

  static const routeName = '/email_verification';

  static Future push({
    required BuildContext context,
  }) {
    return Navigator.pushNamed(
      context,
      routeName,
    );
  }

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification>
    with WidgetsBindingObserver {
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    focusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read(emailVerificationNotipod.notifier).pasteCode();

      if (mounted && Platform.isAndroid) {
        // Workaround to fix bug related to Flutter framework.
        // When app goes to background and comes back,
        // the keyboard is not showing
        // Reproducible only on Android. But even this fix has it flaws.
        // When I half-collapse app and coming back keyboard can't be accessed
        // because this half-collapse doesn't trigger app to go to background,
        // hence, code below won't be executed
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final verification = context.read(emailVerificationNotipod);
          await Future.delayed(const Duration(milliseconds: 200));
          if (verification.controller.value.text.length !=
              emailVerificationCodeLength) {
            if (focusNode.hasFocus) {
              focusNode.unfocus();
              Future.delayed(
                const Duration(microseconds: 1),
                () => focusNode.requestFocus(),
              );
            } else {
              focusNode.requestFocus();
            }
          }
        });
      }
    } else if (state == AppLifecycleState.paused) {
      if (focusNode.hasFocus) {
        focusNode.unfocus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final timer = useProvider(timerNotipod(emailResendCountdown));
    final timerN = useProvider(timerNotipod(emailResendCountdown).notifier);
    final verification = useProvider(emailVerificationNotipod);
    final verificationN = useProvider(emailVerificationNotipod.notifier);
    final authInfo = useProvider(authInfoNotipod);
    final notificationN = useProvider(sNotificationNotipod.notifier);
    final pinError = useValueNotifier(StandardFieldErrorNotifier());
    final loader = useValueNotifier(StackLoaderNotifier());

    focusNode.addListener(() {
      if (focusNode.hasFocus &&
          verification.controller.value.text.length ==
              emailVerificationCodeLength &&
          pinError.value.value) {
        verification.controller.clear();
      }
    });

    analytics(() => sAnalytics.emailVerificationView());

    return ProviderListener<EmailVerificationState>(
      provider: emailVerificationNotipod,
      onChange: (context, state) {
        state.union.maybeWhen(
          error: (Object? error) {
            loader.value.finishLoading();
            pinError.value.enableError();
            notificationN.showError(
              error.toString(),
              id: 1,
            );
          },
          orElse: () {},
        );
      },
      child: SPageFrame(
        loading: loader.value,
        header: Column(
          children: [
            SPaddingH24(
              child: SBigHeader(
                title: intl.emailVerification_emailVerification,
              ),
            ),
            const SStepIndicator(
              loadedPercent: 40,
            ),
          ],
        ),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              child: SPaddingH24(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SpaceH7(),
                    FittedBox(
                      child: Text(
                        intl.emailVerification_enterCode,
                        style: sBodyText1Style.copyWith(
                          color: colors.grey1,
                        ),
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
                    const SpaceH62(),
                    GestureDetector(
                      onLongPress: () => verificationN.pasteCode(),
                      onDoubleTap: () => verificationN.pasteCode(),
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
                          controller: verification.controller,
                          length: emailVerificationCodeLength,
                          onCompleted: (_) {
                            loader.value.startLoadingImmediately();
                            verificationN.verifyCode();
                          },
                          autoFocus: true,
                          onChanged: (_) {
                            pinError.value.disableError();
                          },
                          pinError: pinError.value,
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (timer > 0 && !verification.isResending)
                      ResendInText(
                        text: '${intl.twoFaPhone_youCanResendIn} $timer'
                            ' ${intl.twoFaPhone_seconds}',
                      )
                    else ...[
                      ResendInText(
                        text: '${intl.twoFaPhone_didntReceiveTheCode}?',
                      ),
                      STextButton1(
                        active: true,
                        name: intl.twoFaPhone_resend,
                        onTap: () {
                          timerN.refreshTimer();
                          verificationN.resendCode();
                        },
                      ),
                    ],
                    const SpaceH24(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
