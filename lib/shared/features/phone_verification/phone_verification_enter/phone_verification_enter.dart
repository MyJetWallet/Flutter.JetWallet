import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../helpers/navigator_push.dart';
import '../../../notifiers/enter_phone_notifier/enter_phone_notipod.dart';
import '../phone_verification_confirm/view/phone_verification_confirm.dart';
import 'components/phone_number_bottom_sheet.dart';
import 'components/phone_verification_block.dart';

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PhoneVerificationBlock(
            onChange: (String number) {
              notifier.updatePhoneNumber(number);
            },
            showBottomSheet: () {
              sShowBasicModalBottomSheet(
                context: context,
                removeBottomHeaderPadding: true,
                minHeight: 745.h,
                maxHeight: 745.h,
                scrollable: true,
                children: [
                  const PhoneNumberBottomSheet(),
                ],
              );
            },
            isoCode: state.isoCode ?? '',
          ),
          SPaddingH24(
            child: Baseline(
              baselineType: TextBaseline.alphabetic,
              baseline: 24,
              child: Text(
                'This allow you to send and receive crypto by phone',
                style: sCaptionTextStyle.copyWith(
                  color: SColorsLight().grey1,
                ),
              ),
            ),
          ),
          const Spacer(),
          SPaddingH24(
            child: SPrimaryButton2(
              active:
                  state.isoCode != '' && state.phoneNumber != '' || false,
              name: 'Continue',
              onTap: () {
                final isoCode = state.isoCode;
                final phoneNumber = state.phoneNumber;
                if (isoCode != null && phoneNumber != null) {
                  PhoneVerificationConfirm.push(context, onVerified);
                }
              },
            ),
          ),
          const SpaceH24(),
        ],
      ),
    );
  }
}
