import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/country/store/kyc_profile_countries_store.dart';
import 'package:jetwallet/widgets/flag_item.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

import 'show_user_data_country_picker.dart';

class CountryProfileField extends StatelessObserverWidget {
  const CountryProfileField();

  @override
  Widget build(BuildContext context) {
    final countryInfo = getIt.get<KycProfileCountriesStore>();
    final colors = sKit.colors;

    return ColoredBox(
      color: colors.white,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          sAnalytics.signInFlowSelectCountryView();
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
                            style: STStyles.subtitle1,
                          ),
                        ),
                      ],
                    ),
                  ),
                SStandardField(
                  hideClearButton: true,
                  readOnly: true,
                  controller: TextEditingController()..text = countryInfo.activeCountry != null ? ' ' : '',
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
