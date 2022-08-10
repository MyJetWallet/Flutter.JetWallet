import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../app/shared/components/flag_item.dart';
import '../../../../../shared/providers/service_providers.dart';
import 'notifier/kyc_profile_countries_notipod.dart';
import 'show_user_data_country_picker.dart';

class CountryProfileField extends HookWidget {
  const CountryProfileField();

  @override
  Widget build(BuildContext context) {
    final countryInfo = useProvider(kycProfileCountriesNotipod);
    final intl = useProvider(intlPod);
    final colors = useProvider(sColorPod);
    return ColoredBox(
      color: colors.white,
      child: GestureDetector(
        onTap: () {
          showUserDataCountryPicker(context);
        },
        child: AbsorbPointer(
          child: SPaddingH24(
            child: Stack(
              children: [
                if (countryInfo.activeCountry != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 40.0),
                    child: Row(
                      children: [
                        FlagItem(
                          countryCode: countryInfo.activeCountry!.countryCode,
                        ),
                        const SpaceW10(),
                        Expanded(
                          child: Text(
                            countryInfo.activeCountry!.countryName,
                            style: sSubtitle2Style.copyWith(
                              color: colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                SStandardField(
                  hideClearButton: true,
                  readOnly: true,
                  controller: TextEditingController()
                    ..text = countryInfo.activeCountry != null ? ' ' : '',
                  labelText: intl.user_data_country,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
