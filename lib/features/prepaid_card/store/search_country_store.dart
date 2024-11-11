import 'package:flutter/material.dart';
import 'package:jetwallet/features/phone_verification/utils/simple_number.dart';

import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'search_country_store.g.dart';

class SearchCountryStore extends _SearchCountryStoreBase with _$SearchCountryStore {
  SearchCountryStore({required super.allCountries}) : super();

  static SearchCountryStore of(BuildContext context) => Provider.of<SearchCountryStore>(context);
}

abstract class _SearchCountryStoreBase with Store {
  _SearchCountryStoreBase({required this.allCountries}) {
    searchedCountries.addAll(allCountries);
  }

  final ObservableList<SPhoneNumber> allCountries;

  @observable
  ObservableList<SPhoneNumber> searchedCountries = ObservableList.of([]);

  @action
  void onSarch(String value) {
    final tempList = allCountries.where(
      (country) =>
          country.countryName.toLowerCase().contains(
                value.toLowerCase(),
              ) ||
          country.isoCode.toLowerCase().contains(
                value.toLowerCase(),
              ),
    );
    searchedCountries = ObservableList.of(tempList);
  }
}
