import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../../shared/features/phone_verification/phone_verification_confirm/view/phone_verification_confirm.dart';
import '../../../../../../../shared/features/phone_verification/phone_verification_enter/components/phone_number_bottom_sheet.dart';
import '../../../../../../../shared/features/phone_verification/phone_verification_enter/components/phone_number_search.dart';
import '../../../../../../../shared/features/phone_verification/phone_verification_enter/components/phone_verification_block.dart';
import '../../../../../../../shared/notifiers/phone_number_notifier/phone_number_notipod.dart';

class ChangePhoneNumber extends HookWidget {
  const ChangePhoneNumber({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final statePhoneNumber = useProvider(phoneNumberNotipod);
    final notifierPhoneNumber = useProvider(phoneNumberNotipod.notifier);

    return SPageFrame(
      header: SPaddingH24(
        child: SSmallHeader(
          title: 'Enter phone number',
          onBackButtonTap: () => Navigator.pop(context),
        ),
      ),
      child: Column(
        children: [
          PhoneVerificationBlock(
            onErase: () {
              notifierPhoneNumber.updatePhoneNumber('');
            },
            onChanged: (String number) {
              notifierPhoneNumber.updatePhoneNumber(number);
            },
            showBottomSheet: () {
              notifierPhoneNumber.sortClearCountriesCode();

              final sortWithActiveCountryCode =
              notifierPhoneNumber.sortActiveCountryCode();

              sShowBasicModalBottomSheet(
                context: context,
                removeBottomHeaderPadding: true,
                horizontalPinnedPadding: 0,
                minHeight: 635.h,
                maxHeight: 635.h,
                scrollable: true,
                pinned: PhoneNumberSearch(
                  onErase: () {
                    notifierPhoneNumber.sortClearCountriesCode();
                  },
                  onChange: (String countryName) {
                    if (countryName.isNotEmpty && countryName.length > 1) {
                      notifierPhoneNumber.sortCountriesCode(countryName);
                    } else {
                      notifierPhoneNumber.sortClearCountriesCode();
                    }
                  },
                ),
                children: [
                  PhoneNumberBottomSheet(
                    countriesCodeList: sortWithActiveCountryCode,
                    onTap: (SPhoneNumber country) {
                      notifierPhoneNumber
                          .updateCountryCode(country.countryCode);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
            countryCode: statePhoneNumber.countryCode ?? '',
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
              active: notifierPhoneNumber.setActiveCode(),
              name: 'Continue',
              onTap: () {
                PhoneVerificationConfirm.push(context, () {
                  SuccessScreen.push(
                    context: context,
                    secondaryText: 'New phone number set',
                  );
                });
              },
            ),
          ),
          const SpaceH24(),
        ],
      ),
    );
  }
}
