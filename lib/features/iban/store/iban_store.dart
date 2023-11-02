// ignore_for_file: avoid_bool_literals_in_conditional_expressions
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';
import 'package:simple_networking/modules/wallet_api/models/iban_info/iban_info_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/kyc_profile/country_list_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/profile/profile_set_address_request.dart';

import '../../../core/di/di.dart';
import '../../../core/router/app_router.dart';
import '../../../core/services/kyc_profile_countries.dart';
import '../../auth/user_data/ui/widgets/country/model/kyc_profile_country_model.dart';
part 'iban_store.g.dart';

class IbanStore = IbanStoreBase with _$IbanStore;

abstract class IbanStoreBase with Store {
  IbanStoreBase() {
    loader = StackLoaderStore();

    getAddressBook();
  }

  final formKey = GlobalKey<FormState>();

  static final _logger = Logger('IbanStore');

  @computed
  bool get isIbanOutActive =>
      sSignalRModules.currenciesList.where((element) => element.supportIbanSendWithdrawal).toList().isNotEmpty;

  int initTab = 0;
  void setInitTab(int value) => initTab = value;
  TabController? ibanTabController;
  void setTabController(TabController value) => ibanTabController = value;

  @observable
  StackLoaderStore? loader;

  @observable
  bool isReceive = true;
  @action
  void setIsReceive(bool value) => isReceive = value;

  @observable
  int? month;

  @observable
  int? year;

  @observable
  SPhoneNumber? selectedCountry;

  @observable
  bool streetAddress1Error = false;
  @action
  bool setStreetAddress1Error(bool value) => streetAddress1Error = value;

  @observable
  bool streetAddress2Error = false;
  @action
  bool setStreetAddress2Error(bool value) => streetAddress2Error = value;

  @observable
  bool cityError = false;
  @action
  bool setCityError(bool value) => cityError = value;

  @observable
  bool postalCodeError = false;
  @action
  bool setPostalCodeError(bool value) => postalCodeError = value;

  @observable
  String countrySearch = '';

  @observable
  ObservableList<SPhoneNumber> filteredCountries = ObservableList.of([]);

  @observable
  String streetAddress1 = '';

  TextEditingController streetAddress1Controller = TextEditingController();

  @observable
  String streetAddress2 = '';

  TextEditingController streetAddress2Controller = TextEditingController();

  @observable
  String city = '';

  TextEditingController cityController = TextEditingController();

  @observable
  String postalCode = '';

  TextEditingController postalCodeController = TextEditingController();

  @observable
  bool billingAddressEnableButton = true;

  @observable
  String ibanName = '';

  @observable
  String ibanAddress = '';

  @observable
  String ibanBic = '';

  @observable
  bool toSetupAddress = true;

  @observable
  bool isLoading = false;

  @observable
  bool wasFirstLoad = false;

  @observable
  IbanInfoStatusDto status = IbanInfoStatusDto.notExist;

  @action
  bool setBAEnableButton(bool value) => billingAddressEnableButton = value;

  @computed
  bool get isStreetAddress1Valid {
    return streetAddress1.length >= 2 && streetAddress1.length <= 150;
  }

  @computed
  bool get isStreetAddress2Valid {
    return streetAddress2.isEmpty ? true : streetAddress2.length >= 2 && streetAddress2.length <= 150;
  }

  @computed
  bool get isCityValid {
    return city.length >= 2 && city.length <= 150;
  }

  @computed
  bool get isPostalCodeValid {
    return postalCode.length >= 3 && postalCode.length <= 10;
  }

  @computed
  bool get isBillingAddressValid {
    return isStreetAddress1Valid && isStreetAddress2Valid && isCityValid && isPostalCodeValid;
  }

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

    billingAddressEnableButton = true;
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
  void initCountryState(CountryListResponseModel countriesList) {
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

  @action
  void updateCountrySearch(String value) {
    _logger.log(notifier, 'updateCountrySearch');

    countrySearch = value;
    _filterCountries();
  }

  @action
  void _filterCountries() {
    final newList = List<SPhoneNumber>.from(sPhoneNumbers);

    newList.removeWhere((element) {
      return !_isCountryInSearch(element);
    });

    filteredCountries = ObservableList.of(newList);
  }

  @action
  bool _isCountryInSearch(SPhoneNumber country) {
    final search = countrySearch.toLowerCase().replaceAll(' ', '');
    final name = country.countryName.toLowerCase().replaceAll(' ', '');

    return name.contains(search);
  }

  @action
  void pickCountry(SPhoneNumber country) {
    _logger.log(notifier, 'pickCountry');

    selectedCountry = country;
  }

  @action
  Future<void> saveAddress({
    required VoidCallback onError,
  }) async {
    _logger.log(notifier, 'addCard');

    loader!.startLoading();

    try {
      final model = ProfileSetAddressRequestModel(
        state: '',
        city: city,
        country: activeCountry!.countryCode,
        addressLine1: streetAddress1,
        addressLine2: streetAddress2,
        buildingNumber: '',
        postalCode: postalCode,
      );

      final response = await sNetwork.getWalletModule().postSetAddress(model);

      if (response.hasError) {
        sNotification.showError(
          response.error?.cause ?? '',
          duration: 4,
          id: 1,
          needFeedback: true,
        );

        loader!.finishLoading();
      } else {
        loader!.finishLoading(
          onFinish: () {
            sRouter.pop();
          },
        );
      }
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        duration: 4,
        id: 1,
        needFeedback: true,
      );

      loader!.finishLoading();
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        duration: 4,
        id: 1,
        needFeedback: true,
      );

      loader!.finishLoading();
    }
  }

  @action
  void updateCity(String newCity) {
    _logger.log(notifier, 'updateCity');

    city = newCity.trim();
    cityError = checkOnBadSymbol(city);

    billingAddressEnableButton = true;
  }

  @action
  void updateAddress1(String newAddress) {
    _logger.log(notifier, 'updateAddress1');

    streetAddress1 = newAddress.trim();
    streetAddress1Error = checkOnBadSymbol(streetAddress1);

    billingAddressEnableButton = true;
  }

  @action
  void updateAddress2(String newAddress) {
    _logger.log(notifier, 'updateAddress2');

    streetAddress2 = newAddress.trim();
    streetAddress2Error = checkOnBadSymbol(streetAddress2);

    billingAddressEnableButton = true;
  }

  @action
  void updatePostalCode(String newPostalCode) {
    _logger.log(notifier, 'updatePostalCode');

    postalCode = newPostalCode.trim();

    billingAddressEnableButton = true;
  }

  @action
  void clearBillingDetails() {
    _logger.log(notifier, 'clearBillingDetails');

    streetAddress1 = '';
    streetAddress2 = '';
    city = '';
    postalCode = '';
  }

  bool checkOnBadSymbol(String txt) {
    if (txt.isEmpty) return false;

    final re = RegExp(
      r'^[a-zA-Z\p{N},.:/\s/-]*$',
      unicode: true,
      multiLine: true,
    );

    return !re.hasMatch(txt);
  }

  /// IBAN Send
  @observable
  bool ibanAdressBookLoaded = false;

  @observable
  ObservableList<AddressBookContactModel> contacts = ObservableList.of([]);

  @observable
  ObservableList<AddressBookContactModel> topContacts = ObservableList.of([]);

  @action
  Future<void> getAddressBook() async {
    if (contacts.isEmpty) {
      ibanAdressBookLoaded = false;
    }

    final response = await sNetwork.getWalletModule().getAddressBook('');

    response.pick(
      onData: (data) {
        contacts = ObservableList.of(data.contacts ?? []);
        topContacts = ObservableList.of(data.topContacts ?? []);

        ibanAdressBookLoaded = true;
      },
    );

    contacts.sort((a, b) {
      return b.weight!.compareTo(a.weight!);
    });
  }
}
