import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../app/shared/components/empty_search_result.dart';

import 'country_item/country_profile_item.dart';
import 'notifier/kyc_profile_countries_notipod.dart';

void showUserDataCountryPicker(BuildContext context) {
  context.read(kycProfileCountriesNotipod.notifier).initCountrySearch();

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const _SearchPinned(),
    expanded: true,
    removeBarPadding: true,
    removePinnedPadding: true,
    children: [
      const _Countries(),
      const SpaceH24(),
    ],
  );
}

class _SearchPinned extends HookWidget {
  const _SearchPinned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final intl = useProvider(intlPod);
    final notifier = useProvider(kycProfileCountriesNotipod.notifier);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpaceH20(),
        Text(
          intl.kycCountry_countryOfIssue,
          style: sTextH2Style,
        ),
        SStandardField(
          autofocus: true,
          labelText: intl.showKycCountryPicker_search,
          onChanged: (value) {
            notifier.updateCountryNameSearch(value);
          },
        ),
        const SDivider(),
      ],
    );
  }
}

class _Countries extends HookWidget {
  const _Countries({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(kycProfileCountriesNotipod);
    final notifier = useProvider(kycProfileCountriesNotipod.notifier);
    final notificationN = useProvider(sNotificationNotipod.notifier);
    final intl = useProvider(intlPod);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: state.sortedCountries.length,
        itemBuilder: (context, index) {
          final country = state.sortedCountries[index];
          if (state.sortedCountries.isEmpty) {
            EmptySearchResult(
              text: state.countryNameSearch,
            );
          }
          return CountryProfileItem(
            onTap: () {
              if (country.isBlocked) {
                notificationN.showError(
                  intl.user_data_bottom_sheet_country,
                  id: 1,
                );
              } else {
                notifier.pickCountryFromSearch(country);
                Navigator.pop(context);
              }
            },
            countryCode: country.countryCode,
            countryName: country.countryName,
            isBlocked: country.isBlocked,
          );
        },
      ),
    );
  }
}
