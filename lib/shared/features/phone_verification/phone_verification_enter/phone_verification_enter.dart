import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../components/custom_international_phone_number_input.dart';
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
    final controller = useTextEditingController();

    return SPageFrameWithPadding(
      header: SSmallHeader(
        title: 'Enter phone number',
        onBackButtonTap: () => Navigator.pop(context),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SpaceH4(),
          CustomInternationalPhoneNumberInput(
            controller: controller,
            onChanged: (PhoneNumber number) {
              notifier.updatePhoneNumber(number.phoneNumber);
            },
            onValidated: (bool valid) {
              notifier.updateValid(valid: valid);
            },
          ),
          const SpaceH10(),
          Text(
            'This allow you to send and receive crypto by phone',
            style: sCaptionTextStyle.copyWith(
              color: SColorsLight().grey1,
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
    );
  }
}
