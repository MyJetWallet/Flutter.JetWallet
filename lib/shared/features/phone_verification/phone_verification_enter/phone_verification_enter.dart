import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../helpers/navigator_push.dart';
import '../../../notifiers/enter_phone_notifier/enter_phone_notipod.dart';
import '../phone_verification_confirm/view/phone_verification_confirm.dart';

class PhoneVerificationEnter extends HookWidget {
  const PhoneVerificationEnter({
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
      PhoneVerificationEnter(
        onVerified: onVerified,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = useProvider(enterPhoneNotipod);
    final notifier = useProvider(enterPhoneNotipod.notifier);

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: 'Enter phone number',
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: SPaddingH24(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // const SpaceH40(),
            const SpaceH4(),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Code',
                        style: sCaptionTextStyle.copyWith(
                          color: SColorsLight().grey2,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Container(
                        child: Text(
                          'Phone number',
                          style: sCaptionTextStyle.copyWith(
                            color: SColorsLight().grey2,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Container(
                //   height: 88.h,
                //   child: InternationalPhoneNumberInput(
                //     searchBoxDecoration: InputDecoration(
                //       fillColor: Colors.red,
                //       suffixIcon: Icon(Icons.sixty_fps),
                //       prefixIcon: Icon(Icons.ten_k),
                //       enabledBorder: const OutlineInputBorder(
                //
                //         // borderSide: const BorderSide(color: Colors.grey, width: 0.0),
                //       ),
                //     ),
                //
                //     hintText: '',
                //     textStyle: sSubtitle1Style,
                //     textAlignVertical: TextAlignVertical.top,
                //     ignoreBlank: true,
                //     autoValidateMode: AutovalidateMode.always,
                //     selectorTextStyle: sSubtitle2Style,
                //     inputBorder: const OutlineInputBorder(
                //       borderSide: BorderSide.none,
                //     ),
                //     onInputChanged: (number) {
                //       notifier.updatePhoneNumber(number.phoneNumber);
                //     },
                //
                //     spaceBetweenSelectorAndTextField: 2.0,
                //     onInputValidated: (valid) {
                //       notifier.updateValid(valid: valid);
                //     },
                //   ),
                // ),
              ],
            ),
            InternationalPhoneNumberInput(
              textStyle: sSubtitle1Style,
              textAlignVertical: TextAlignVertical.top,
              ignoreBlank: true,
              autoValidateMode: AutovalidateMode.always,
              onInputChanged: (number) {
                notifier.updatePhoneNumber(number.phoneNumber);
              },
              onInputValidated: (valid) {
                notifier.updateValid(valid: valid);
              },
            ),
            const SpaceH10(),

            Text(
              'This allow you to send and receive crypto by phone',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey,
              ),
            ),
            const Spacer(),

            SPrimaryButton2(
              active: true,
              name: 'Continue',
              onTap: () {
                if (state.valid) {
                  PhoneVerificationConfirm.push(context, onVerified);
                }
              },
            ),
            const SpaceH24(),
          ],
        ),
      ),
    );
  }
}
