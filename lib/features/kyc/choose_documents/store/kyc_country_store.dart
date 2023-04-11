import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/kyc/models/kyc_country_model.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'kyc_country_store.g.dart';

@lazySingleton
class KycCountryStore extends _KycCountryStoreBase with _$KycCountryStore {
  KycCountryStore() : super();

  static _KycCountryStoreBase of(BuildContext context) =>
      Provider.of<KycCountryStore>(context, listen: false);
}

abstract class _KycCountryStoreBase with Store {
  _KycCountryStoreBase() {
    final userInfo = getIt.get<UserInfoService>();

    countryOfRegistration = userInfo.countryOfRegistration;
    countries = ObservableList.of(sSignalRModules.kycCountries);
    sortedCountries = ObservableList.of(sSignalRModules.kycCountries);
    activeCountry = sSignalRModules.kycCountries.isNotEmpty
        ? sSignalRModules.kycCountries[0]
        : const KycCountryModel(
            countryCode: '',
            countryName: '',
            isBlocked: false,
            acceptedDocuments: [],
          );

    identifyCountryByUserRegister(countryOfRegistration);
  }

  final userInfo = getIt.get<UserInfoService>();

  static final _logger = Logger('KycCountryStore');

  @observable
  ObservableList<KycCountryModel> countries = ObservableList.of([]);

  @observable
  ObservableList<KycCountryModel> sortedCountries = ObservableList.of([]);

  @observable
  String countryNameSearch = '';

  @observable
  KycCountryModel? activeCountry;

  @observable
  String? countryOfRegistration;

  @action
  void initCountrySearch() {
    updateCountryNameSearch('');
  }

  @action
  void updateCountryNameSearch(String cNameSearch) {
    _logger.log(notifier, 'updateCountryNameSearch');

    countryNameSearch = cNameSearch;

    _filterByCountryNameSearch();
  }

  @action
  void pickCountryFromSearch(KycCountryModel country) {
    _logger.log(notifier, 'pickCountryFromSearch');

    activeCountry = country;
  }

  @action
  void identifyCountryByUserRegister(String? countryOfRegistration) {
    final country = <KycCountryModel>[];

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

    final newList = List<KycCountryModel>.from(countries);

    newList.removeWhere(
      (KycCountryModel element) => !element.countryName.toLowerCase().contains(
            countryNameSearch.toLowerCase(),
          ),
    );

    sortedCountries = ObservableList.of(newList);
  }
}
