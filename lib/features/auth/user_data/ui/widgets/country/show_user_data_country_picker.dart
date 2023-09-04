import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/country/store/kyc_profile_countries_store.dart';
import 'package:jetwallet/widgets/empty_search_result.dart';
import 'package:simple_kit/simple_kit.dart';

import 'country_item/country_profile_item.dart';

void showUserDataCountryPicker(BuildContext context) {
  final profileCountriesStore = getIt.get<KycProfileCountriesStore>();

  profileCountriesStore.initCountrySearch();

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: _SearchPinned(
      store: profileCountriesStore,
    ),
    expanded: true,
    removeBarPadding: true,
    removePinnedPadding: true,
    children: [
      _Countries(
        store: profileCountriesStore,
      ),
      const SpaceH24(),
    ],
  );
}

class _SearchPinned extends StatelessObserverWidget {
  const _SearchPinned({
    required this.store,
  });

  final KycProfileCountriesStore store;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpaceH20(),
        Text(
          intl.kycCountry_countryOfIssue,
          style: sTextH4Style,
        ),
        SStandardField(
          controller: TextEditingController(),
          autofocus: true,
          labelText: intl.showKycCountryPicker_search,
          onChanged: (value) {
            store.updateCountryNameSearch(value);
          },
        ),
        const SDivider(),
      ],
    );
  }
}

class _Countries extends StatelessObserverWidget {
  const _Countries({
    required this.store,
  });

  final KycProfileCountriesStore store;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        itemCount: store.sortedCountries.length,
        itemBuilder: (context, index) {
          final country = store.sortedCountries[index];
          if (store.sortedCountries.isEmpty) {
            EmptySearchResult(
              text: store.countryNameSearch,
            );
          }

          return CountryProfileItem(
            onTap: () {
              if (country.isBlocked) {
                sNotification.showError(
                  intl.user_data_bottom_sheet_country,
                  id: 1,
                );
              } else {
                store.pickCountryFromSearch(country);

                sRouter.pop();
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
