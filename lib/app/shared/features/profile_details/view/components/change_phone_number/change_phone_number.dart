import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../../shared/features/phone_verification/phone_verification_confirm/view/phone_verification_confirm.dart';
import '../../../../../../../shared/features/phone_verification/phone_verification_enter/components/phone_number_bottom_sheet.dart';
import '../../../../../../../shared/features/phone_verification/phone_verification_enter/components/phone_number_search.dart';
import '../../../../../../../shared/features/phone_verification/phone_verification_enter/components/phone_verification_block.dart';
import '../../../../../../../shared/notifiers/phone_number_notifier/phone_number_notipod.dart';
import '../../../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../notifier/change_phone_notifier/change_phone_notipod.dart';

class ChangePhoneNumber extends HookWidget {
  const ChangePhoneNumber({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final phoneNumber = useProvider(phoneNumberNotipod);
    final phoneNumberN = useProvider(phoneNumberNotipod.notifier);
    final changePhoneN = useProvider(changePhoneNotipod.notifier);
    final changePhone = useProvider(changePhoneNotipod);
    final userInfoN = useProvider(userInfoNotipod.notifier);
    final colors = useProvider(sColorPod);

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
              phoneNumberN.updatePhoneNumber('');
            },
            onChanged: (String phone) {
              changePhoneN.updatePhone(phone);
              phoneNumberN.updatePhoneNumber(phone);
            },
            showBottomSheet: () {
              phoneNumberN.sortClearCountriesCode();

              final sortWithActiveCountryCode =
                  phoneNumberN.sortActiveCountryCode();

              sShowBasicModalBottomSheet(
                context: context,
                removePinnedPadding: true,
                horizontalPinnedPadding: 0,

                /// TODO isn't optimized for small devices
                minHeight: 635.0,
                scrollable: true,
                pinned: PhoneNumberSearch(
                  onErase: () {
                    phoneNumberN.sortClearCountriesCode();
                  },
                  onChange: (String countryCode) {
                    changePhoneN.updateIsoCode(countryCode);
                    if (countryCode.isNotEmpty && countryCode.length > 1) {
                      phoneNumberN.sortCountriesCode(countryCode);
                    } else {
                      phoneNumberN.sortClearCountriesCode();
                    }
                  },
                ),
                children: [
                  PhoneNumberBottomSheet(
                    countriesCodeList: sortWithActiveCountryCode,
                    onTap: (SPhoneNumber country) {
                      changePhoneN.updateIsoCode(country.countryCode);
                      phoneNumberN.updateCountryCode(country.countryCode);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
            countryCode: phoneNumber.countryCode ?? '',
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
              active: phoneNumberN.setActiveCode(),
              name: 'Continue',
              onTap: () {
                PhoneVerificationConfirm.push(
                  context: context,
                  onVerified: () {
                    userInfoN.updatePhone(changePhone.phoneNumber);
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
