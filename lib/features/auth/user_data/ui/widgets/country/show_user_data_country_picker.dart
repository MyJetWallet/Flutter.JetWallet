import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/country/store/kyc_profile_countries_store.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:jetwallet/widgets/empty_search_result.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc_profile/country_list_response_model.dart';

import 'country_item/country_profile_item.dart';

void showUserDataCountryPicker(BuildContext context) {
  final profileCountriesStore = getIt.get<KycProfileCountriesStore>();

  profileCountriesStore.initCountrySearch();

  showBasicBottomSheet(
    context: context,
    header: BasicBottomSheetHeaderWidget(
      title: intl.kycCountry_countryOfIssue,
      searchOptions: SearchOptions(
        hint: intl.showKycCountryPicker_search,
        onChange: (value) {
          profileCountriesStore.updateCountryNameSearch(value);
        },
      ),
    ),
    expanded: true,
    children: [
      _Countries(
        store: profileCountriesStore,
      ),
      const SpaceH40(),
    ],
  );
}

void showCountryOfBank(BuildContext context, Function(Country) onTap) {
  final store = KycProfileCountriesStore();

  showBasicBottomSheet(
    context: context,
    header: BasicBottomSheetHeaderWidget(
      title: intl.address_book_country_of_recepients_bank,
      searchOptions: SearchOptions(
        hint: intl.showKycCountryPicker_search,
        onChange: (value) {
          store.updateCountryNameSearch(value);
        },
      ),
    ),
    expanded: true,
    children: [
      Observer(
        builder: (context) {
          return ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: store.sortedCountries.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final country = store.sortedCountries[index];
              if (store.sortedCountries.isEmpty) {
                EmptySearchResult(
                  text: store.countryNameSearch,
                );
              }

              return CountryProfileItem(
                onTap: () {
                  onTap(
                    Country(
                      countryCode: country.countryCode,
                      countryName: country.countryName,
                      isBlocked: country.isBlocked,
                    ),
                  );

                  sRouter.maybePop();
                },
                countryCode: country.countryCode,
                countryName: country.countryName,
                isBlocked: false,
              );
            },
          );
        },
      ),
      const SpaceH40(),
    ],
  );
}

class _Countries extends StatelessObserverWidget {
  const _Countries({
    required this.store,
  });

  final KycProfileCountriesStore store;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      itemCount: store.sortedCountries.length,
      physics: const NeverScrollableScrollPhysics(),
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

              sAnalytics.signInFlowErrorCountryBlocked(
                erroCode: intl.user_data_bottom_sheet_country,
              );
            } else {
              store.pickCountryFromSearch(country);

              sRouter.maybePop();
            }
          },
          countryCode: country.countryCode,
          countryName: country.countryName,
          isBlocked: country.isBlocked,
        );
      },
    );
  }
}
