import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../../shared/logging/levels.dart';
import '../../model/kyc_country_model.dart';

class KycCountriesNotifier extends StateNotifier<KycCountriesState> {
  KycCountriesNotifier({
    this.countryOfRegistration,
    required this.read,
    required this.countries,
  }) : super(
          const KycCountriesState(),
        ) {
    state = state.copyWith(
      countries: countries.countries,
      sortedCountries: countries.countries,
    );

    _setCountryByRegistration(countryOfRegistration);
  }

  final Reader read;
  final KycCountriesState countries;
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

  void pickCountryFromSearch(KycCountryModel country) {
    _logger.log(notifier, 'pickCountryFromSearch');

    state = state.copyWith(activeCountry: country);
  }

  void _setCountryByRegistration(String? countryOfRegistration) {
    _logger.log(notifier, '_setCountryByRegistration');

    final country = <KycCountryModel>[];

    if (countryOfRegistration != null) {
      final countryCodeOfRegistration = countryOfRegistration.toLowerCase();

      for (var i = 0; i < state.countries.length; i++) {
        if (state.countries[i].countryCode.toLowerCase() ==
            countryCodeOfRegistration) {
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

    final newList = List<KycCountryModel>.from(state.countries);

    newList.removeWhere(
      (KycCountryModel element) => !element.countryName.contains(
        state.countryNameSearch,
      ),
    );
    state = state.copyWith(sortedCountries: List.from(newList));
  }
}
