import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/features/phone_verification/store/phone_verification_store.dart';
import 'package:jetwallet/utils/store/timer_store.dart';
import 'package:jetwallet/widgets/pin_code_field.dart';
import 'package:jetwallet/widgets/texts/resend_in_text.dart';
import 'package:jetwallet/widgets/texts/resend_rich_text.dart';
import 'package:jetwallet/widgets/texts/verification_description_text.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

const codeLength = 4;

class PhoneVerificationArgs {
  PhoneVerificationArgs({
    this.showChangeTextAlert = false,
    this.sendCodeOnInitState = true,
    required this.phoneNumber,
    required this.onVerified,
    this.activeDialCode,
  });

  final bool sendCodeOnInitState;
  final bool showChangeTextAlert;
  final String phoneNumber;
  final void Function() onVerified;
  final SPhoneNumber? activeDialCode;
}

class PhoneVerification extends StatelessWidget {
  const PhoneVerification({
    Key? key,
    required this.args,
  }) : super(key: key);

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
          create: (_) => TimerStore(30),
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
    Key? key,
    required this.args,
  }) : super(key: key);

  final PhoneVerificationArgs args;

  @override
  Widget build(BuildContext context) {
    final store = PhoneVerificationStore.of(context);
    final timer = TimerStore.of(context);

    // TODO add phoneVerificationCountdown
    final colors = sKit.colors;

    store.focusNode.addListener(() {
      if (store.focusNode.hasFocus &&
          store.controller.value.text.length == codeLength &&
          store.pinFieldError.value) {
        store.controller.clear();
      }
    });

    return SPageFrame(
      loaderText: intl.phoneVerification_pleaseWait,
      loading: store.loader,
      header: SPaddingH24(
        child: SBigHeader(
          title: intl.phoneVerification_phoneConfirmation,
          onBackButtonTap: () => Navigator.pop(context),
          isSmallSize: true,
        ),
      ),
      child: SPaddingH24(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            VerificationDescriptionText(
              text: '${intl.phoneVerification_enterSmsCode} ',
              boldText:
                  '${store.dialCode?.countryCode ?? ""} ${store.phoneNumber.replaceAll(store.dialCode?.countryCode ?? "", "")}',
            ),
            const SpaceH18(),
            if (args.showChangeTextAlert) ...[
              RichText(
                text: TextSpan(
                  style: sBodyText1Style.copyWith(
                    color: colors.grey1,
                  ),
                  children: [
                    TextSpan(
                      text: intl.phoneVerification_pleaseContact,
                    ),
                    TextSpan(
                      text: ' ${intl.phoneVerification_support}',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          sRouter.push(
                            CrispRouter(
                              welcomeText: intl.crispSendMessage_hi,
                            ),
                          );
                        },
                      style: sBodyText1Style.copyWith(
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
                  onCompleted: (_) => store.verifyCode(),
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
                  intl.profileDetails_waitForCall,
                  style: sCaptionTextStyle.copyWith(
                    color: colors.grey2,
                  ),
                ),
              )
            else ...[
              if (timer.time > 0 && !store.showResend) ...[
                ResendInText(
                  text: '${intl.twoFaPhone_youCanReceive} ${timer.time}'
                      ' ${intl.phoneVerification_seconds}',
                ),
              ] else ...[
                ResendRichText(
                  isPhone: true,
                  onTap: () async {
                    await store.sendCode();
                    timer.refreshTimer();

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
