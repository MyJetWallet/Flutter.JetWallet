import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/kyc_profile_countries.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/country/model/kyc_profile_country_model.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'kyc_profile_countries_store.g.dart';

class KycProfileCountriesStore extends _KycProfileCountriesStoreBase
    with _$KycProfileCountriesStore {
  KycProfileCountriesStore() : super();

  static _KycProfileCountriesStoreBase of(BuildContext context) =>
      Provider.of<KycProfileCountriesStore>(context, listen: false);
}

abstract class _KycProfileCountriesStoreBase with Store {
  _KycProfileCountriesStoreBase() {
    final countriesList = getIt.get<KycProfileCountries>().profileCountries;
    final value = <KycProfileCountryModel>[];

    if (countriesList.countries.isNotEmpty) {
      for (var i = 0; i < countriesList.countries.length; i++) {
        value.add(
          KycProfileCountryModel(
            countryCode: countriesList.countries[i].countryCode,
            countryName: countriesList.countries[i].countryName,
            isBlocked: countriesList.countries[i].isBlocked,
          ),
        );
      }
    }

    countries = ObservableList.of(value);
    sortedCountries = ObservableList.of(value);

    final userCountry = getIt.get<ProfileGetUserCountry>();
    _identifyCountryByUserRegister(userCountry.profileUserCountry.countryCode);
  }

  static final _logger = Logger('SendByPhoneInputNotifier');

  @observable
  ObservableList<KycProfileCountryModel> countries = ObservableList.of([]);

  @observable
  ObservableList<KycProfileCountryModel> sortedCountries =
      ObservableList.of([]);

  @observable
  String countryNameSearch = '';

  @observable
  KycProfileCountryModel? activeCountry;

  @action
  void initCountrySearch() {
    updateCountryNameSearch('');
  }

  @action
  void updateCountryNameSearch(String newCountryNameSearch) {
    _logger.log(notifier, 'updateCountryNameSearch');

    countryNameSearch = newCountryNameSearch;

    _filterByCountryNameSearch();
  }

  @action
  void pickCountryFromSearch(KycProfileCountryModel country) {
    _logger.log(notifier, 'pickCountryFromSearch');

    activeCountry = country;
  }

  @action
  void _identifyCountryByUserRegister(String? countryOfRegistration) {
    final country = <KycProfileCountryModel>[];

    if (countryOfRegistration != null) {
      for (var i = 0; i < countries.length; i++) {
        if (countries[i].countryCode.toLowerCase() ==
            countryOfRegistration.toLowerCase()) {
          country.add(countries[i]);
        }
      }
    }

    if (country.isNotEmpty) {
      activeCountry = country[0];
    }
  }

  @action
  void _filterByCountryNameSearch() {
    _logger.log(notifier, '_filterByCountryNameSearch');

    final newList = List<KycProfileCountryModel>.from(countries);

    newList.removeWhere(
      (KycProfileCountryModel element) =>
          !element.countryName.toLowerCase().contains(
                countryNameSearch.toLowerCase(),
              ),
    );

    sortedCountries = ObservableList.of(newList);
  }
}
