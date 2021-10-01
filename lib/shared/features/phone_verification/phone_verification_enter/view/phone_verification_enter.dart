import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

import '../../../../../router/notifier/startup_notifier/startup_notipod.dart';
import '../../../../components/buttons/app_button_solid.dart';
import '../../../../components/page_frame/page_frame.dart';
import '../../../../components/spacers.dart';
import '../../../../helpers/navigator_push.dart';
import '../../model/phone_verification_trigger_union.dart';
import '../../phone_verification_confirm/view/phone_verification_confirm.dart';
import '../notifier/phone_verification_enter_notipod.dart';

class PhoneVerificationEnter extends HookWidget {
  const PhoneVerificationEnter({
    Key? key,
    required this.trigger,
  }) : super(key: key);

  final PhoneVerificationTriggerUnion trigger;

  static void push(
    BuildContext context,
    PhoneVerificationTriggerUnion trigger,
  ) {
    navigatorPush(
      context,
      PhoneVerificationEnter(
        trigger: trigger,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = useProvider(phoneVerificationEnterNotipod(trigger));
    final notifier = useProvider(
      phoneVerificationEnterNotipod(trigger).notifier,
    );

    return PageFrame(
      header: 'Enter phone number',
      onBackButton: () => trigger.when(
        startup: () {
          context.read(startupNotipod.notifier).quitPhoneVerification();
        },
        security: () => Navigator.pop(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH40(),
          Text(
            'Your Phone Number',
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black,
            ),
          ),
          const SpaceH4(),
          InternationalPhoneNumberInput(
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
          AppButtonSolid(
            active: state.valid,
            name: 'Continue',
            onTap: () {
              if (state.valid) {
                PhoneVerificationConfirm.push(context, trigger);
              }
            },
          )
        ],
      ),
    );
  }
}
