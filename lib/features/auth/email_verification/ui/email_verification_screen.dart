import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/deep_link_service.dart';
import 'package:jetwallet/core/services/logout_service/logout_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/auth/email_verification/model/email_verification_union.dart';
import 'package:jetwallet/features/auth/email_verification/store/email_verification_store.dart';
import 'package:jetwallet/utils/helpers/open_email_app.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:jetwallet/widgets/pin_code_field.dart';
import 'package:jetwallet/widgets/texts/resend_in_text.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/headers/simple_auth_header.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:universal_io/io.dart';

class EmailVerification extends StatelessWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TimerStore>(
          create: (_) => TimerStore(emailResendCountdown),
          dispose: (context, store) => store.dispose(),
        ),
      ],
      builder: (context, child) {
        return const _EmailVerificationBody();
      },
    );
  }
}

class _EmailVerificationBody extends StatefulObserverWidget {
  const _EmailVerificationBody({Key? key}) : super(key: key);

  @override
  State<_EmailVerificationBody> createState() => __EmailVerificationBodyState();
}

class __EmailVerificationBodyState extends State<_EmailVerificationBody>
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
    getIt.get<EmailVerificationStore>().clearStore();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      getIt.get<EmailVerificationStore>().pasteCode();

      if (mounted && Platform.isAndroid) {
        // Workaround to fix bug related to Flutter framework.
        // When app goes to background and comes back,
        // the keyboard is not showing
        // Reproducible only on Android. But even this fix has it flaws.
        // When I half-collapse app and coming back keyboard can't be accessed
        // because this half-collapse doesn't trigger app to go to background,
        // hence, code below won't be executed
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          final verification = getIt.get<EmailVerificationStore>();

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
    final colors = sKit.colors;
    final timer = TimerStore.of(context);

    final verification = getIt.get<EmailVerificationStore>();

    final authInfo = getIt.get<AppStore>().authState;

    final userInfoN = getIt.get<UserInfoService>();

    focusNode.addListener(() {
      if (focusNode.hasFocus &&
          verification.controller.value.text.length ==
              emailVerificationCodeLength &&
          verification.pinError.value) {
        verification.controller.clear();
      }
    });

    return SPageFrame(
      loaderText: intl.register_pleaseWait,
      loading: verification.loader,
      header: SAuthHeader(
        title: intl.emailVerification_emailVerification,
        customIconButton: SIconButton(
          onTap: () {
            sRouter.replaceAll([const OnboardingRoute()]);
          },
          defaultIcon: const SCloseIcon(),
          pressedIcon: const SClosePressedIcon(),
        ),
        isAutoSize: true,
      ),
      child: SingleChildScrollView(
        child: SPaddingH24(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SpaceH4(),
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
