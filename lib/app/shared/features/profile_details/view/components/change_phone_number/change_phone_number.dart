import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../../shared/features/phone_verification/phone_verification_confirm/view/phone_verification_confirm.dart';
import '../../../../../../../shared/helpers/navigator_push.dart';
import '../../../../../../../shared/notifiers/phone_number_notifier/phone_number_notipod.dart';
import '../bottom_sheet/change_phone_dial_code_picker.dart';

class ChangePhoneNumber extends HookWidget {
  const ChangePhoneNumber({
    Key? key,
    required this.onVerified,
  }) : super(key: key);

  final Function() onVerified;

  static void push({
    required BuildContext context,
    required Function() onVerified,
  }) {
    navigatorPush(
      context,
      ChangePhoneNumber(
        onVerified: onVerified,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final state = useProvider(phoneNumberNotipod);
    final notifier = useProvider(phoneNumberNotipod.notifier);

    return SPageFrame(
      color: colors.grey5,
      header: SPaddingH24(
        child: SSmallHeader(
          title: 'Enter phone number',
          onBackButtonTap: () {
            notifier.clearCountryCode();
            Navigator.pop(context);
          },
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
                      changePhoneDialCodePicker(context);
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
                      alignLabelWithHint: true,
                      onChanged: (String phone) {
                        notifier.updatePhoneNumber(
                          phone,
                        );
                      },
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
              active: state.phoneNumber.isNotEmpty,
              name: 'Continue',
              onTap: () {
                notifier.updateCountryCode(
                  state.dialCodeController.text,
                );
                PhoneVerificationConfirm.push(
                  context: context,
                  onVerified: () {
                    SuccessScreen.push(
                      context: context,
                      secondaryText: 'New phone number set',
                    );
                  },
                  isChangeTextAlert: false,
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
