import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../shared/providers/service_providers.dart';
import '../register/components/referral_code/referral_code.dart';
import 'components/birth_date/notifier/selected_date_notipod.dart';
import 'components/birth_date/show_birrth_date_picker.dart';
import 'components/country/country_field.dart';
import 'notifier/selected_date_notipod.dart';

class UserDataScreen extends HookWidget {
  const UserDataScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    final userDataN = useProvider(userDataNotipod.notifier);
    final userData = useProvider(userDataNotipod);
    final birthDateInfo = useProvider(selectedDateNotipod);
    final birthDateController = TextEditingController();
    birthDateController.text = birthDateInfo.selectedDate;
    final loader = useValueNotifier(StackLoaderNotifier());

    return SPageFrame(
      loading: loader.value,
      color: colors.grey5,
      header: SPaddingH24(
        child: SBigHeader(
          customIconButton: const SpaceH24(),
          title: intl.user_data_whats_your_name,
        ),
      ),
      child: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SStepIndicator(
                    loadedPercent: 60,
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ColoredBox(
                              color: colors.white,
                              child: SPaddingH24(
                                child: SStandardField(
                                  labelText: intl.user_data_first_name,
                                  errorNotifier: userData.firstNameError,
                                  onChanged: (val) {
                                    userDataN.updateFirstName(val);
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SpaceW1(),
                          Expanded(
                            child: ColoredBox(
                              color: colors.white,
                              child: SPaddingH24(
                                child: SStandardField(
                                  labelText: intl.user_data_last_name,
                                  errorNotifier: userData.lastNameError,
                                  onChanged: (val) {
                                    userDataN.updateLastName(val);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SpaceH1(),
                  ColoredBox(
                    color: colors.white,
                    child: GestureDetector(
                      onTap: () {
                        showBirthDatePicker(context);
                      },
                      child: AbsorbPointer(
                        child: SPaddingH24(
                          child: SStandardField(
                              labelText: intl.user_data_date_of_birth,
                              hideClearButton: true,
                              readOnly: true,
                              controller: birthDateController),
                        ),
                      ),
                    ),
                  ),
                  const SpaceH1(),
                  const CountryProfileField(),
                  const SpaceH16(),
                  const Spacer(),
                  SPaddingH24(
                    child: SPrimaryButton4(
                      name: intl.register_continue,
                      onTap: () {
                        userDataN.saveUserData(loader);
                      },
                      active: userData.activeButton,
                    ),
                  ),
                  const SpaceH24(),
                  const ReferralCode(),
                  const SpaceH24(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
