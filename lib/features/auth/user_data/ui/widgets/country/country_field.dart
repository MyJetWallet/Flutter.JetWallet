import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/country/store/kyc_profile_countries_store.dart';
import 'package:jetwallet/widgets/flag_item.dart';
import 'package:simple_analytics/simple_analytics.dart';

import 'show_user_data_country_picker.dart';

class CountryProfileField extends StatelessObserverWidget {
  const CountryProfileField();

  @override
  Widget build(BuildContext context) {
    final countryInfo = getIt.get<KycProfileCountriesStore>();
    final colors = SColorsLight();

    return Container(
      color: colors.white,
      height: 80,
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          sAnalytics.signInFlowSelectCountryView();
          showUserDataCountryPicker(context);
        },
        child: AbsorbPointer(
          child: Stack(
            children: [
              SInput(
                isDisabled: true,
                controller: TextEditingController()..text = countryInfo.activeCountry != null ? ' ' : '',
                label: intl.user_data_country,
              ),
              if (countryInfo.activeCountry != null)
                Padding(
                  padding: const EdgeInsets.only(top: 33.0, left: 24),
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
            ],
          ),
        ),
      ),
    );
  }
}
