import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/kyc_profile_countries.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/auth/user_data/ui/widgets/country/model/kyc_profile_country_model.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc/apply_country_request_model.dart';

part 'kyc_aid_countries_store.g.dart';

class KycAidCountriesStore extends _KycAidCountriesStoreBase with _$KycAidCountriesStore {
  KycAidCountriesStore({super.isCardFlow = false}) : super();

  static _KycAidCountriesStoreBase of(BuildContext context) =>
      Provider.of<KycAidCountriesStore>(context, listen: false);
}

abstract class _KycAidCountriesStoreBase with Store {
  _KycAidCountriesStoreBase({this.isCardFlow = false}) {
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

  final bool isCardFlow;

  static final _logger = Logger('KycAidCountriesStore');

  @observable
  StackLoaderStore loader = StackLoaderStore();

  @observable
  ObservableList<KycProfileCountryModel> countries = ObservableList.of([]);

  @observable
  ObservableList<KycProfileCountryModel> sortedCountries = ObservableList.of([]);

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
        if (countries[i].countryCode.toLowerCase() == countryOfRegistration.toLowerCase()) {
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
      (KycProfileCountryModel element) => !element.countryName.toLowerCase().contains(
            countryNameSearch.toLowerCase(),
          ),
    );

    sortedCountries = ObservableList.of(newList);
  }

  @action
  Future<void> applyCountry() async {
    try {
      loader.startLoadingImmediately();
      final model = ApplyCountryRequestModel(
        countryCode: activeCountry?.countryCode ?? '',
      );
      final responce = await sNetwork.getWalletModule().postKYCAplyCountry(model);

      responce.pick(
        onData: (data) {
          final url = data.url;
          sRouter.replace(KycAidWebViewRouter(url: url));
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            id: 1,
          );
        },
      );
    } catch (e) {
      sNotification.showError(
        intl.something_went_wrong_try_again,
        id: 1,
      );
    } finally {
      loader.finishLoading();
    }
  }
}
