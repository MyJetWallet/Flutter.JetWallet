// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'dart:convert';

import 'package:credit_card_validator/credit_card_validator.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:openpgp/openpgp.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/add_card/add_card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:uuid/uuid.dart';
part 'add_circle_card_store.g.dart';

class AddCircleCardStore extends AddCircleCardStoreBase
    with _$AddCircleCardStore {
  AddCircleCardStore() : super();

  static AddCircleCardStoreBase of(BuildContext context) =>
      Provider.of<AddCircleCardStore>(context, listen: false);
}

abstract class AddCircleCardStoreBase with Store {
  AddCircleCardStoreBase() {
    loader = StackLoaderStore();

    _initState();
    _updateBillingAddressFromStorage();
  }

  static final _logger = Logger('AddCircleCarStore');

  @observable
  StackLoaderStore? loader;

  @observable
  int? month;

  @observable
  int? year;

  @observable
  SPhoneNumber? selectedCountry;

  @observable
  bool cardNumberError = false;
  @action
  bool setCardNumberError(bool value) => cardNumberError = value;

  @observable
  bool expiryDateError = false;
  @action
  bool setExpiryDateError(bool value) => expiryDateError = value;

  @observable
  bool cvvError = false;
  @action
  bool setCvvError(bool value) => cvvError = value;

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
  bool districtError = false;
  @action
  bool setdDistrictError(bool value) => districtError = value;

  @observable
  bool postalCodeError = false;
  @action
  bool setdPostalCodeError(bool value) => postalCodeError = value;

  @observable
  String expiryDate = '';

  TextEditingController expiryDateController = TextEditingController();

  @observable
  String countrySearch = '';

  @observable
  ObservableList<SPhoneNumber> filteredCountries = ObservableList.of([]);

  @observable
  String cardNumber = '';

  TextEditingController cardNumberController = TextEditingController();

  @observable
  String cvv = '';

  TextEditingController cvvController = TextEditingController();

  @observable
  String cardholderName = '';

  TextEditingController cardholderNameController = TextEditingController();

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
  String district = '';

  TextEditingController districtController = TextEditingController();

  @observable
  String postalCode = '';

  TextEditingController postalCodeController = TextEditingController();

  @observable
  bool billingAddressEnableButton = true;
  @action
  bool setBAEnableButton(bool value) => billingAddressEnableButton = value;

  @computed
  bool get isCardNumberValid {
    return CreditCardValidator().validateCCNum(cardNumber).isValid;
  }

  @computed
  bool get isCvvValid {
    final result = CreditCardValidator().validateCCNum(cardNumber);
    final ccvResult = CreditCardValidator().validateCVV(cvv, result.ccType);

    return ccvResult.isValid;
  }

  @computed
  bool get isExpiryDateValid {
    return CreditCardValidator().validateExpDate(expiryDate).isValid;
  }

  @computed
  bool get isCardholderNameValid {
    return cardholderName.split(' ').length >= 2;
  }

  @computed
  bool get isStreetAddress1Valid {
    return streetAddress1.length >= 2 && streetAddress1.length <= 150;
  }

  @computed
  bool get isStreetAddress2Valid {
    return streetAddress2.isEmpty
        ? true
        : streetAddress2.length >= 2 && streetAddress2.length <= 150;
  }

  @computed
  bool get isCityValid {
    return city.length >= 2 && city.length <= 150;
  }

  @computed
  bool get isDistrictValid {
    return district.length >= 2 && district.length <= 150;
  }

  @computed
  bool get isPostalCodeValid {
    return postalCode.length >= 3 && postalCode.length <= 10;
  }

  @computed
  bool get isCardDetailsValid {
    return isCardNumberValid &&
        isCvvValid &&
        isExpiryDateValid &&
        isCardholderNameValid;
  }

  @computed
  bool get isBillingAddressValid {
    return isStreetAddress1Valid &&
        isStreetAddress2Valid &&
        isCityValid &&
        isDistrictValid &&
        isPostalCodeValid;
  }

  @action
  void _initState() {
    final userInfo = sUserInfo.userInfo;

    final numbers = sPhoneNumbers.where((element) {
      return element.isoCode == userInfo.countryOfResidence;
    });

    final country = numbers.isEmpty ? sPhoneNumbers.first : numbers.first;

    selectedCountry = country;
    filteredCountries = ObservableList.of(sPhoneNumbers);
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
  Future<void> addCard({
    required Function(CircleCard) onSuccess,
    required VoidCallback onError,
  }) async {
    _logger.log(notifier, 'addCard');

    loader!.startLoading();

    try {
      final response = await sNetwork.getWalletModule().getEncryptionKey();

      response.pick(
        onData: (data) async {
          final _cardNumber = cardNumber.replaceAll('\u{2005}', '');

          final base64Decoded = base64Decode(data.encryptionKey);
          final utf8Decoded = utf8.decode(base64Decoded);
          final encrypted = await OpenPGP.encrypt(
            '{"number":"$_cardNumber","cvv":"$cvv"}',
            utf8Decoded,
          );
          final utf8Encoded = utf8.encode(encrypted);
          final base64Encoded = base64Encode(utf8Encoded);

          final expDate = expiryDate.split('/');

          final model = AddCardRequestModel(
            keyId: data.keyId,
            requestGuid: const Uuid().v4(),
            encryptedData: base64Encoded,
            billingName: cardholderName,
            billingCity: city,
            billingCountry: selectedCountry!.isoCode,
            billingLine1: streetAddress1,
            billingLine2: streetAddress2,
            billingDistrict: district,
            billingPostalCode: postalCode,
            expMonth: int.parse(expDate[0]),
            expYear: int.parse('20${expDate[1]}'),
          );

          final response = await sNetwork.getWalletModule().postAddCard(model);

          response.pick(
            onData: (card) {
              _saveBillingAddressToStorage();
              loader!.finishLoading(onFinish: () => onSuccess(card));
            },
            onError: (error) {
              sNotification.showError(
                error.cause,
                duration: 4,
                id: 1,
                needFeedback: true,
              );

              loader!.finishLoading(onFinish: onError);
            },
          );
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            duration: 4,
            id: 1,
            needFeedback: true,
          );

          loader!.finishLoading(onFinish: onError);
        },
      );
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        duration: 4,
        id: 1,
        needFeedback: true,
      );

      loader!.finishLoading(onFinish: onError);
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        duration: 4,
        id: 1,
        needFeedback: true,
      );

      loader!.finishLoading(onFinish: onError);
    }
  }

  @action
  void updateCardNumber(String _cardNumber) {
    _logger.log(notifier, 'updateCardNumber');

    cardNumber = _cardNumber;

    // [xxxx xxxx xxxx xxxx]
    cardNumberError = cardNumber.length == 19
        ? isCardNumberValid
            ? false
            : true
        : false;
  }

  @action
  void updateCvv(String _cvv) {
    _logger.log(notifier, 'updateCvv');

    cvv = _cvv;

    // [xxx]
    cvvError = cvv.length == 3 ? !isCvvValid : false;
  }

  @action
  void updateExpiryDate(String _expiryDate) {
    _logger.log(notifier, 'updateExpiryDate');

    expiryDate = _expiryDate;

    // [xx/xx]
    expiryDateError = expiryDate.length >= 4
        ? isExpiryDateValid
            ? false
            : true
        : false;
  }

  @action
  void updateCardholderName(String _cardholderName) {
    _logger.log(notifier, 'updateCardholderName');

    cardholderName = _cardholderName.trim();
  }

  @action
  void updateCity(String _city) {
    _logger.log(notifier, 'updateCity');

    city = _city.trim();
  }

  @action
  void updateAddress1(String _address) {
    _logger.log(notifier, 'updateAddress1');

    streetAddress1 = _address.trim();
  }

  @action
  void updateAddress2(String _address) {
    _logger.log(notifier, 'updateAddress2');

    streetAddress2 = _address.trim();
  }

  @action
  void updateDistrict(String _district) {
    _logger.log(notifier, 'updateDistrict');

    district = _district.trim();
  }

  @action
  void updatePostalCode(String _postalCode) {
    _logger.log(notifier, 'updatePostalCode');

    postalCode = _postalCode.trim();
  }

  @action
  void clearBillingDetails() {
    _logger.log(notifier, 'clearBillingDetails');

    streetAddress1 = '';
    streetAddress2 = '';
    city = '';
    district = '';
    postalCode = '';
  }

  @action
  void _saveBillingAddressToStorage() {
    final json = {
      'streetAddress1': streetAddress1,
      'streetAddress2': streetAddress2,
      'city': city,
      'district': district,
      'postalCode': postalCode,
      'billingCountry': selectedCountry!.isoCode,
    };

    sLocalStorageService.setJson(billingInformationKey, json);
  }

  @action
  Future<void> _updateBillingAddressFromStorage() async {
    final storage = sLocalStorageService;
    final string = await storage.getValue(billingInformationKey);

    if (string != null) {
      final json = jsonDecode(string) as Map<String, dynamic>;

      final isoCode = json['billingCountry'] as String;
      final country = sPhoneNumbers.firstWhere((e) => e.isoCode == isoCode);

      streetAddress1 = json['streetAddress1'] as String;
      streetAddress2 = json['streetAddress2'] as String;
      city = json['city'] as String;
      district = json['district'] as String;
      postalCode = json['postalCode'] as String;
      selectedCountry = country;
    }
  }
}
