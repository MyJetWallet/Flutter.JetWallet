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
    KycCountriesState(
      activeCountry: countries.countries.isNotEmpty ? countries.countries[0]
          : const KycCountryModel(
        countryCode: '',
        countryName: '',
        isBlocked: false,
        acceptedDocuments: [],
      ),
      countries: countries.countries,
      sortedCountries: countries.countries,
    ),
  ) {
    state = state.copyWith(
      countries: countries.countries,
      sortedCountries: countries.countries,
    );

    _identifyCountryByUserRegister(countryOfRegistration);
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

  void _identifyCountryByUserRegister(String? countryOfRegistration) {
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
          (KycCountryModel element) =>
      !element.countryName.toLowerCase().contains(
        state.countryNameSearch.toLowerCase(),
      ),
    );
    state = state.copyWith(sortedCountries: List.from(newList));
  }
}
