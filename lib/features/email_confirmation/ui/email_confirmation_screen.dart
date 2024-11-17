import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/email_confirmation/store/email_confirmation_store.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/helpers/open_email_app.dart';
import 'package:jetwallet/utils/helpers/standard_field_error_notifier.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:jetwallet/widgets/pin_code_field.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../models/email_confirmation_union.dart';

@RoutePage(name: 'EmailConfirmationRouter')
class EmailConfirmationScreen extends StatelessWidget {
  const EmailConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<EmailConfirmationStore>(
          create: (_) => EmailConfirmationStore(),
          dispose: (context, store) => store.dispose(),
        ),
      ],
      builder: (context, child) {
        return const _EmailConfirmationScreenBody();
      },
    );
  }
}

class _EmailConfirmationScreenBody extends StatefulObserverWidget {
  const _EmailConfirmationScreenBody();

  @override
  State<_EmailConfirmationScreenBody> createState() => __EmailConfirmationScreenBodyState();
}

class __EmailConfirmationScreenBodyState extends State<_EmailConfirmationScreenBody> with WidgetsBindingObserver {
  final focusNode = FocusNode();
  final pinError = StandardFieldErrorNotifier();

  final timer = TimerStore(emailResendCountdown);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    EmailConfirmationStore.of(context).init(timer);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    focusNode.dispose();
    pinError.dispose();
    timer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    final confirmation = EmailConfirmationStore.of(context);

    final authInfo = getIt.get<AppStore>().authState;

    focusNode.addListener(() {
      if (focusNode.hasFocus &&
          confirmation.controller.value.text.length == emailVerificationCodeLength &&
          pinError.value) {
        confirmation.controller.clear();
      }
    });

    return ReactionBuilder(
      builder: (context) {
        return reaction<EmailConfirmationUnion>(
          (_) => confirmation.union,
          (result) {
            result.maybeWhen(
              input: () {},
              error: (Object? error) {
                pinError.enableError();
              },
              orElse: () {},
            );
          },
          fireImmediately: true,
        );
      },
      child: PopScope(
        canPop: !confirmation.loader.loading,
        child: SPageFrame(
          loaderText: intl.register_pleaseWait,
          loading: confirmation.loader,
          header: GlobalBasicAppBar(
            title: intl.emailConfirmation_title,
            hasLeftIcon: false,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SpaceH7(),
                      Text(
                        intl.emailConfirmation_text,
                        maxLines: 3,
                        style: STStyles.body1Medium.copyWith(
                          color: colors.grey1,
                        ),
                      ),
                      Text(
                        authInfo.email,
                        style: STStyles.body1Medium,
                      ),
                      const SpaceH17(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SButtonContext(
                            type: SButtonContextType.basicInverted,
                            text: intl.emailVerification_openEmail,
                            onTap: () => openEmailApp(context),
                          ),
                        ],
                      ),
                      const SpaceH40(),
                      GestureDetector(
                        onLongPress: () => confirmation.pasteCode(),
                        onDoubleTap: () => confirmation.pasteCode(),
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
                            controller: confirmation.controller,
                            length: emailVerificationCodeLength,
                            onCompleted: (_) {
                              confirmation.verifyCode();
                            },
                            autoFocus: true,
                            onChanged: (_) {
                              pinError.disableError();
                            },
                            pinError: pinError,
                          ),
                        ),
                      ),
                      const SpaceH7(),
                      SResendButton(
                        active: !confirmation.isResending,
                        timer: confirmation.showResendButton ? 0 : timer.time,
                        onTap: () {
                          confirmation.controller.clear();
                          confirmation.updateResendButton(false);

                          confirmation.resendCode(
                            onSuccess: () {
                              timer.refreshTimer();
                              confirmation.updateResendButton(false);
                            },
                          );
                        },
                        text1: intl.emailVerification_youCanResendIn,
                        text2: intl.emailVerification_seconds,
                        text3: intl.emailVerification_didntReceiveTheCode,
                        textResend: intl.emailVerification_resend,
                      ),
                      const Spacer(),
                      SSecondaryButton1(
                        active: true,
                        name: intl.emailConfirmation_cancel,
                        onTap: () => navigateToRouter(),
                      ),
                      const SpaceH42(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
