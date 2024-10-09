import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/intercom/intercom_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/change_email/store/change_email_verification_store.dart';
import 'package:jetwallet/utils/helpers/open_email_app.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:jetwallet/widgets/pin_code_field.dart';
import 'package:jetwallet/widgets/texts/resend_in_text.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:universal_io/io.dart';

@RoutePage(name: 'ChangeEmailVerificationRouter')
class ChangeEmailVerificationScreen extends StatelessWidget {
  const ChangeEmailVerificationScreen({
    required this.verificationToken,
    required this.pinCode,
    required this.newEmail,
    super.key,
  });

  final String verificationToken;
  final String pinCode;
  final String newEmail;

  @override
  Widget build(BuildContext context) {
    if (!getIt.isRegistered<ChangeEmailVerificationStore>()) {
      getIt.registerSingleton<ChangeEmailVerificationStore>(
        ChangeEmailVerificationStore(
          verificationToken,
          pinCode,
          newEmail,
        ),
      );
    } else {
      getIt.unregister<ChangeEmailVerificationStore>();
      getIt.registerSingleton<ChangeEmailVerificationStore>(
        ChangeEmailVerificationStore(
          verificationToken,
          pinCode,
          newEmail,
        ),
      );
    }

    return MultiProvider(
      providers: [
        Provider<TimerStore>(
          create: (_) => TimerStore(emailResendCountdown),
          dispose: (context, store) => store.dispose(),
        ),
      ],
      builder: (context, child) {
        return const _ChangeEmailVerificationBody();
      },
    );
  }
}

class _ChangeEmailVerificationBody extends StatefulObserverWidget {
  const _ChangeEmailVerificationBody();

  @override
  State<_ChangeEmailVerificationBody> createState() => __ChangeEmailVerificationBodyState();
}

class __ChangeEmailVerificationBodyState extends State<_ChangeEmailVerificationBody> with WidgetsBindingObserver {
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
    getIt.get<ChangeEmailVerificationStore>().clearStore();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ChangeEmailVerificationStore.of(context).pasteCode();

      if (mounted && Platform.isAndroid) {
        // Workaround to fix bug related to Flutter framework.
        // When app goes to background and comes back,
        // the keyboard is not showing
        // Reproducible only on Android. But even this fix has it flaws.
        // When I half-collapse app and coming back keyboard can't be accessed
        // because this half-collapse doesn't trigger app to go to background,
        // hence, code below won't be executed
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final verification = getIt.get<ChangeEmailVerificationStore>();

          await Future.delayed(const Duration(milliseconds: 200));

          if (verification.controller.value.text.length != emailVerificationCodeLength) {
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
    final colors = sKit.colors;
    final timer = TimerStore.of(context);

    final verification = getIt.get<ChangeEmailVerificationStore>();

    final userInfoN = getIt.get<UserInfoService>();

    focusNode.addListener(() {
      if (focusNode.hasFocus &&
          verification.controller.value.text.length == emailVerificationCodeLength &&
          verification.pinError.value) {
        verification.controller.clear();
      }
    });

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      loading: verification.loader,
      header: SimpleLargeAppbar(
        title: intl.change_email_email_verification,
        hasRightIcon: true,
        titleMaxLines: 2,
        rightIcon: SafeGesture(
          onTap: () async {
            if (showZendesk) {
              await getIt.get<IntercomService>().login();
              await getIt.get<IntercomService>().showMessenger();
            } else {
              await sRouter.push(
                CrispRouter(
                  welcomeText: intl.crispSendMessage_hi,
                ),
              );
            }
          },
          child: Assets.svg.medium.chat.simpleSvg(),
        ),
        leftIcon: SIconButton(
          onTap: () {
            sRouter.popUntil(
              (route) => route.settings.name == ProfileDetailsRouter.name,
            );
          },
          defaultIcon: const SCloseIcon(),
          pressedIcon: const SClosePressedIcon(),
        ),
      ),
      child: SingleChildScrollView(
        child: SPaddingH24(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpaceH4(),
              RichText(
                text: TextSpan(
                  text: intl.change_email_email_verification_hint,
                  style: STStyles.body1Semibold.copyWith(
                    color: SColorsLight().gray10,
                  ),
                  children: [
                    TextSpan(
                      text: verification.email,
                      style: STStyles.body1Semibold.copyWith(
                        color: SColorsLight().black,
                      ),
                    ),
                  ],
                ),
              ),
              const SpaceH16(),
              SClickableLinkText(
                text: intl.emailVerification_openEmail,
                onTap: () => openEmailApp(context),
              ),
              const SpaceH61(),
              GestureDetector(
                onLongPress: () => verification.pasteCode(),
                onDoubleTap: () => verification.pasteCode(),
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
                      userInfoN.updateIsJustLogged(value: true);
                      verification.loader.startLoadingImmediately();
                      verification.verifyCode();
                    },
                    autoFocus: true,
                    onChanged: (_) {
                      verification.pinError.disableError();
                    },
                    pinError: verification.pinError,
                  ),
                ),
              ),
              // const Spacer(),
              if (timer.time > 0 && !verification.isResending) ...[
                ResendInText(
                  text: '${intl.twoFaPhone_youCanResendIn} ${timer.time}'
                      ' ${intl.twoFaPhone_seconds}',
                ),
              ] else ...[
                ResendInText(
                  text: '${intl.twoFaPhone_didntReceiveTheCode}?',
                ),
                const SpaceH30(),
                STextButton1(
                  active: !verification.isResending,
                  name: intl.twoFaPhone_resend,
                  color: colors.blue,
                  onTap: () {
                    timer.refreshTimer();
                    verification.resendCode(timer);
                  },
                ),
              ],
              const SpaceH24(),
            ],
          ),
        ),
      ),
    );
  }
}
