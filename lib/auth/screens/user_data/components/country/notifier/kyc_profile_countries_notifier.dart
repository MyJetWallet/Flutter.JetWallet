import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../../app/shared/providers/profile_user_country_pod/kyc_profile_countries_spod.dart';
import '../../../../../../shared/logging/levels.dart';
import '../model/kyc_profile_country_model.dart';

class KycProfileCountriesNotifier
    extends StateNotifier<KycProfileCountriesState> {
  KycProfileCountriesNotifier({
    this.countryOfRegistration,
    required this.read,
    required this.countries,
  }) : super(
          KycProfileCountriesState(
            countries: countries.countries,
            sortedCountries: countries.countries,
          ),
        ) {
    state = state.copyWith(
      countries: countries.countries,
      sortedCountries: countries.countries,
    );

    final userCountry = read(profileUserCountryFpod);
    userCountry.whenData(
      (value) => {_identifyCountryByUserRegister(value.countryCode)},
    );
  }

  final Reader read;
  final KycProfileCountriesState countries;
  final String? countryOfRegistration;

  static final _logger = Logger('SendByPhoneInputNotifier');

  void initCountrySearch() {
    updateCountryNameSearch('');
  }

  void updateCountryNameSearch(String countryNameSearch) {
    _logger.log(notifier, 'updateCountryNameSearch');

    state = state.copyWith(countryNameSearch: countryNameSearch);

    _filterByCountryNameSearch();
  }

  void pickCountryFromSearch(KycProfileCountryModel country) {
    _logger.log(notifier, 'pickCountryFromSearch');

    state = state.copyWith(activeCountry: country);
  }

  void _identifyCountryByUserRegister(String? countryOfRegistration) {
    final country = <KycProfileCountryModel>[];

    if (countryOfRegistration != null) {
      for (var i = 0; i < state.countries.length; i++) {
        if (state.countries[i].countryCode.toLowerCase() ==
            countryOfRegistration.toLowerCase()) {
          country.add(state.countries[i]);
        }
      }
    }

    if (country.isNotEmpty) {
      state = state.copyWith(activeCountry: country[0]);
    }
  }

  void _filterByCountryNameSearch() {
    _logger.log(notifier, '_filterByCountryNameSearch');

    final newList = List<KycProfileCountryModel>.from(state.countries);

    newList.removeWhere(
      (KycProfileCountryModel element) =>
          !element.countryName.toLowerCase().contains(
                state.countryNameSearch.toLowerCase(),
              ),
    );
    state = state.copyWith(sortedCountries: List.from(newList));
  }
}
