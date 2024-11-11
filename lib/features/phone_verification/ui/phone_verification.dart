import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/intercom/intercom_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/phone_verification/store/phone_verification_store.dart';
import 'package:jetwallet/features/phone_verification/utils/simple_number.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:jetwallet/widgets/pin_code_field.dart';
import 'package:jetwallet/widgets/texts/resend_in_text.dart';
import 'package:jetwallet/widgets/texts/resend_rich_text.dart';
import 'package:jetwallet/widgets/texts/verification_description_text.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import '../../../core/di/di.dart';
import '../../../core/services/logout_service/logout_service.dart';

int codeLength = 4;

class PhoneVerificationArgs {
  PhoneVerificationArgs({
    this.showChangeTextAlert = false,
    this.sendCodeOnInitState = true,
    this.isDeviceBinding = false,
    required this.phoneNumber,
    required this.onVerified,
    this.activeDialCode,
    this.isUnlimitTransferConfirm = false,
    this.transactionId,
    this.onBackTap,
    this.onLoaderStart,
  }) {
    if (isUnlimitTransferConfirm) {
      codeLength = 6;
    }
  }

  final bool sendCodeOnInitState;
  final bool showChangeTextAlert;
  final bool isDeviceBinding;
  final String phoneNumber;
  final void Function() onVerified;
  final SPhoneNumber? activeDialCode;
  final bool isUnlimitTransferConfirm;
  final String? transactionId;
  final void Function()? onBackTap;
  final void Function()? onLoaderStart;
}

@RoutePage(name: 'PhoneVerificationRouter')
class PhoneVerification extends StatelessWidget {
  const PhoneVerification({
    super.key,
    required this.args,
  });

  final PhoneVerificationArgs args;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PhoneVerificationStore>(
          create: (_) => PhoneVerificationStore(args),
          dispose: (context, store) => store.dispose(),
        ),
        Provider<TimerStore>(
          create: (_) => TimerStore(1000000),
          dispose: (context, store) => store.dispose(),
        ),
      ],
      builder: (context, child) {
        return PhoneVerificationBody(
          args: args,
        );
      },
    );
  }
}

/// Called in 2 cases:
/// 1. when we need to verfiy user before change number flow
/// 2. when we need to verify a new number from change number flow
class PhoneVerificationBody extends StatelessObserverWidget {
  const PhoneVerificationBody({
    super.key,
    required this.args,
  });

  final PhoneVerificationArgs args;

  @override
  Widget build(BuildContext context) {
    final store = PhoneVerificationStore.of(context);

    // TODO add phoneVerificationCountdown
    final colors = sKit.colors;

    store.focusNode.addListener(() {
      if (store.focusNode.hasFocus && store.controller.value.text.length == codeLength && store.pinFieldError.value) {
        store.controller.clear();
      }
    });

    return SPageFrame(
      loaderText: intl.phoneVerification_pleaseWait,
      loading: store.loader,
      header: SimpleLargeAppbar(
        title: intl.confirm_with_sms,
        hasRightIcon: true,
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
        leftIcon: args.sendCodeOnInitState
            ? SIconButton(
                onTap: () {
                  if (args.isDeviceBinding || args.isUnlimitTransferConfirm) {
                    getIt<AppRouter>().maybePop();
                  } else {
                    getIt<AppRouter>().popUntilRoot();
                    getIt<LogoutService>().logout(
                      'TWO FA, logout',
                      withLoading: false,
                      callbackAfterSend: () {},
                    );

                    getIt<AppRouter>().maybePop();
                  }

                  args.onBackTap?.call();
                },
                defaultIcon: const SBackIcon(),
                pressedIcon: const SBackPressedIcon(),
              )
            : null,
      ),
      child: SPaddingH24(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            VerificationDescriptionText(
              text: '${intl.phoneVerification_enterSmsCode} ',
              boldText: store.phoneNumber.contains(
                store.dialCode?.countryCode ?? '',
              )
                  ? '${store.dialCode?.countryCode ?? ""} '
                      '${store.phoneNumber.replaceAll(
                      store.dialCode?.countryCode ?? "",
                      "",
                    )}'
                  : store.phoneNumber.replaceAll(
                      store.dialCode?.countryCode ?? '',
                      '',
                    ),
            ),
            const SpaceH18(),
            if (args.showChangeTextAlert) ...[
              RichText(
                text: TextSpan(
                  style: STStyles.body1Medium.copyWith(
                    color: colors.grey1,
                  ),
                  children: [
                    TextSpan(
                      text: intl.phoneVerification_pleaseContact,
                    ),
                    TextSpan(
                      text: ' ${intl.phoneVerification_support}',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          if (showZendesk) {
                            await getIt.get<IntercomService>().showMessenger();
                          } else {
                            await sRouter.push(
                              CrispRouter(
                                welcomeText: intl.crispSendMessage_hi,
                              ),
                            );
                          }
                        },
                      style: STStyles.body1Medium.copyWith(
                        color: colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SpaceH45(),
            GestureDetector(
              onLongPress: () => store.pasteCode(),
              onDoubleTap: () => store.pasteCode(),
              onTap: () {
                store.focusNode.unfocus();

                Future.delayed(const Duration(microseconds: 100), () {
                  if (!store.focusNode.hasFocus) {
                    store.focusNode.requestFocus();
                  }
                });
              },
              child: AbsorbPointer(
                child: PinCodeField(
                  focusNode: store.focusNode,
                  length: codeLength,
                  controller: store.controller,
                  autoFocus: true,
                  mainAxisAlignment: MainAxisAlignment.center,
                  onCompleted: (_) {
                    if (args.sendCodeOnInitState) {
                      store.verifyFullCode(args.onLoaderStart ?? () {});
                    } else {
                      store.verifyCode();
                    }
                  },
                  onChanged: (_) {
                    store.pinFieldError.disableError();
                  },
                  pinError: store.pinFieldError,
                ),
              ),
            ),

            /// TODO update legacy resend
            if (store.resendTapped)
              Center(
                child: Text(
                  args.isUnlimitTransferConfirm ? '' : intl.profileDetails_waitForCall,
                  style: STStyles.captionMedium.copyWith(
                    color: colors.grey2,
                  ),
                ),
              )
            else ...[
              if (store.time > 0 && !store.showResend) ...[
                ResendInText(
                  text: '${intl.twoFaPhone_youCanReceive} ${store.time}'
                      ' ${intl.phoneVerification_seconds}',
                ),
              ] else ...[
                ResendRichText(
                  isPhone: !args.isUnlimitTransferConfirm,
                  onTap: () async {
                    sAnalytics.signInFlowPhoneReceiveCodePhoneCall();

                    if (args.sendCodeOnInitState) {
                      await store.sendFullCode(false);
                    } else {
                      await store.sendCode(false);
                    }
                    store.refreshTimer();

                    store.updateShowResend(
                      sResend: false,
                    );
                  },
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}
