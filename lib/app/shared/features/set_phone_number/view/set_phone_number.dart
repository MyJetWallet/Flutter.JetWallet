import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../shared/helpers/navigator_push.dart';
import '../../../../../shared/helpers/navigator_push_replacement.dart';
import '../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../phone_verification/view/phone_verification.dart';
import '../notifier/set_phone_number_notipod.dart';
import 'components/show_country_phone_number_picker.dart';

/// Called in 2 cases:
/// 1. when we want to change number
/// 2. when we are enabling 2FA but we haven't added phone number yet
class SetPhoneNumber extends HookWidget {
  const SetPhoneNumber({
    Key? key,
    this.then,
    required this.successText,
  }) : super(key: key);

  final Function()? then;
  final String successText;

  static void push({
    Function()? then,
    required BuildContext context,
    required String successText,
  }) {
    navigatorPush(
      context,
      SetPhoneNumber(
        successText: successText,
        then: then,
      ),
    );
  }

  static void pushReplacement({
    Function()? then,
    required BuildContext context,
    required String successText,
  }) {
    navigatorPushReplacement(
      context,
      SetPhoneNumber(
        successText: successText,
        then: then,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final state = useProvider(setPhoneNumberNotipod);
    final notifier = useProvider(setPhoneNumberNotipod.notifier);
    useListenable(state.dialCodeController);
    useListenable(state.phoneNumberController);

    return SPageFrame(
      loading: state.loader,
      color: colors.grey5,
      header: const SPaddingH24(
        child: SSmallHeader(
          title: 'Enter phone number',
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Material(
            color: colors.white,
            child: Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    left: 24,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: colors.grey4,
                      ),
                    ),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      showCountryPhoneNumberPicker(context);
                    },
                    child: SizedBox(
                      width: 76,
                      child: AbsorbPointer(
                        child: SStandardField(
                          labelText: 'Code',
                          readOnly: true,
                          hideClearButton: true,
                          controller: state.dialCodeController,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SPaddingH24(
                    child: SStandardField(
                      labelText: 'Phone number',
                      autofocus: true,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      controller: state.phoneNumberController,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SPaddingH24(
            child: Baseline(
              baselineType: TextBaseline.alphabetic,
              baseline: 24,
              child: Text(
                'This allow you to send and receive crypto by phone',
                style: sCaptionTextStyle.copyWith(
                  color: colors.grey1,
                ),
              ),
            ),
          ),
          const Spacer(),
          SPaddingH24(
            child: SPrimaryButton2(
              active: state.isReadyToContinue,
              name: 'Continue',
              onTap: () {
                notifier.sendCode(
                  then: () {
                    PhoneVerification.push(
                      context: context,
                      args: PhoneVerificationArgs(
                        phoneNumber: state.phoneNumber,
                        sendCodeOnInitState: false,
                        onVerified: () {
                          final userInfoN = context.read(
                            userInfoNotipod.notifier,
                          );

                          userInfoN.updatePhoneVerified(phoneVerified: true);
                          userInfoN.updateTwoFaStatus(enabled: true);
                          userInfoN.updatePhone(state.phoneNumber);

                          SuccessScreen.push(
                            context: context,
                            secondaryText: successText,
                            then: then,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const SpaceH24(),
        ],
      ),
    );
  }
}
