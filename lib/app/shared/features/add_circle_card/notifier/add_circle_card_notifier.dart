import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:openpgp/openpgp.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/circle/model/add_card/add_card_request_model.dart';
import 'package:simple_networking/services/circle/model/circle_card.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';
import 'package:uuid/uuid.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/notifiers/user_info_notifier/user_info_notipod.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../../../shared/services/local_storage_service.dart';
import 'add_circle_card_state.dart';

class AddCircleCardNotifier extends StateNotifier<AddCircleCardState> {
  AddCircleCardNotifier(this.read)
      : super(
          AddCircleCardState(
            loader: StackLoaderNotifier(),
            cardNumberError: StandardFieldErrorNotifier(),
            expiryDateError: StandardFieldErrorNotifier(),
            cvvError: StandardFieldErrorNotifier(),
            streetAddress1Error: StandardFieldErrorNotifier(),
            streetAddress2Error: StandardFieldErrorNotifier(),
            cityError: StandardFieldErrorNotifier(),
            districtError: StandardFieldErrorNotifier(),
            postalCodeError: StandardFieldErrorNotifier(),
          ),
        ) {
    _initState();
    _updateBillingAddressFromStorage();
  }

  final Reader read;

  static final _logger = Logger('AddCircleCardNotifier');

  void _initState() {
    final userInfo = read(userInfoNotipod);

    final numbers = sPhoneNumbers.where((element) {
      return element.isoCode == userInfo.countryOfResidence;
    });

    final country = numbers.isEmpty ? sPhoneNumbers.first : numbers.first;

    state = state.copyWith(
      selectedCountry: country,
      filteredCountries: sPhoneNumbers,
    );
  }

  void updateCountrySearch(String value) {
    _logger.log(notifier, 'updateCountrySearch');

    state = state.copyWith(countrySearch: value);
    _filterCountries();
  }

  void _filterCountries() {
    final newList = List<SPhoneNumber>.from(sPhoneNumbers);

    newList.removeWhere((element) {
      return !_isCountryInSearch(element);
    });

    state = state.copyWith(filteredCountries: List.from(newList));
  }

  bool _isCountryInSearch(SPhoneNumber country) {
    final search = state.countrySearch.toLowerCase().replaceAll(' ', '');
    final name = country.countryName.toLowerCase().replaceAll(' ', '');

    return name.contains(search);
  }

  void pickCountry(SPhoneNumber country) {
    _logger.log(notifier, 'pickCountry');

    state = state.copyWith(selectedCountry: country);
  }

  Future<void> addCard({
    required Function(CircleCard) onSuccess,
    required VoidCallback onError,
  }) async {
    _logger.log(notifier, 'addCard');

    final intl = read(intlPod);

    state.loader!.startLoading();

    try {
      final response =
          await read(circleServicePod).encryptionKey(intl.localeName);

      final cardNumber = state.cardNumber.replaceAll('\u{2005}', '');

      final base64Decoded = base64Decode(response.encryptionKey);
      final utf8Decoded = utf8.decode(base64Decoded);
      final encrypted = await OpenPGP.encrypt(
        '{"number":"$cardNumber","cvv":"${state.cvv}"}',
        utf8Decoded,
      );
      final utf8Encoded = utf8.encode(encrypted);
      final base64Encoded = base64Encode(utf8Encoded);

      final expDate = state.expiryDate.split('/');

      final model = AddCardRequestModel(
        keyId: response.keyId,
        requestGuid: const Uuid().v4(),
        encryptedData: base64Encoded,
        billingName: state.cardholderName,
        billingCity: state.city,
        billingCountry: state.selectedCountry!.isoCode,
        billingLine1: state.streetAddress1,
        billingLine2: state.streetAddress2,
        billingDistrict: state.district,
        billingPostalCode: state.postalCode,
        expMonth: int.parse(expDate[0]),
        expYear: int.parse('20${expDate[1]}'),
      );

      final card = await read(circleServicePod).addCard(
        model,
        intl.localeName,
      );
      _saveBillingAddressToStorage();
      state.loader!.finishLoading(onFinish: () => onSuccess(card));
    } on ServerRejectException catch (error) {
      read(sNotificationNotipod.notifier).showError(
        error.cause,
        duration: 4,
        id: 1,
      );
      state.loader!.finishLoading(onFinish: onError);
    } catch (error) {
      read(sNotificationNotipod.notifier).showError(
        intl.something_went_wrong_try_again2,
        duration: 4,
        id: 1,
      );
      state.loader!.finishLoading(onFinish: onError);
    }
  }

  void updateCardNumber(String cardNumber) {
    _logger.log(notifier, 'updateCardNumber');

    state = state.copyWith(cardNumber: cardNumber);

    // [xxxx xxxx xxxx xxxx]
    if (cardNumber.length == 19) {
      if (state.isCardNumberValid) {
        state.cardNumberError!.disableError();
      } else {
        state.cardNumberError!.enableError();
      }
    } else {
      state.cardNumberError!.disableError();
    }
  }

  void updateCvv(String cvv) {
    _logger.log(notifier, 'updateCvv');

    state = state.copyWith(cvv: cvv);

    // [xxx]
    if (cvv.length == 3) {
      if (state.isCvvValid) {
        state.cvvError!.disableError();
      } else {
        state.cvvError!.enableError();
      }
    } else {
      state.cvvError!.disableError();
    }
  }

  void updateExpiryDate(String expiryDate) {
    _logger.log(notifier, 'updateExpiryDate');

    state = state.copyWith(expiryDate: expiryDate);

    // [xx/xx]
    if (expiryDate.length >= 4) {
      if (state.isExpiryDateValid) {
        state.expiryDateError!.disableError();
      } else {
        state.expiryDateError!.enableError();
      }
    } else {
      state.expiryDateError!.disableError();
    }
  }

  void updateCardholderName(String cardholderName) {
    _logger.log(notifier, 'updateCardholderName');

    state = state.copyWith(cardholderName: cardholderName.trim());
  }

  void updateCity(String city) {
    _logger.log(notifier, 'updateCity');

    state = state.copyWith(city: city.trim());
  }

  void updateAddress1(String address) {
    _logger.log(notifier, 'updateAddress1');

    state = state.copyWith(streetAddress1: address.trim());
  }

  void updateAddress2(String address) {
    _logger.log(notifier, 'updateAddress2');

    state = state.copyWith(streetAddress2: address.trim());
  }

  void updateDistrict(String district) {
    _logger.log(notifier, 'updateDistrict');

    state = state.copyWith(district: district.trim());
  }

  void updatePostalCode(String postalCode) {
    _logger.log(notifier, 'updatePostalCode');

    state = state.copyWith(postalCode: postalCode.trim());
  }

  void clearBillingDetails() {
    _logger.log(notifier, 'clearBillingDetails');

    state = state.copyWith(
      streetAddress1: '',
      streetAddress2: '',
      city: '',
      district: '',
      postalCode: '',
    );
  }

  void _saveBillingAddressToStorage() {
    final json = {
      'streetAddress1': state.streetAddress1,
      'streetAddress2': state.streetAddress2,
      'city': state.city,
      'district': state.district,
      'postalCode': state.postalCode,
      'billingCountry': state.selectedCountry!.isoCode,
    };

    read(localStorageServicePod).setJson(billingInformationKey, json);
  }

  Future<void> _updateBillingAddressFromStorage() async {
    final storage = read(localStorageServicePod);
    final string = await storage.getValue(billingInformationKey);

    if (string != null) {
      final json = jsonDecode(string) as Map<String, dynamic>;

      final isoCode = json['billingCountry'] as String;
      final country = sPhoneNumbers.firstWhere((e) => e.isoCode == isoCode);

      state = state.copyWith(
        streetAddress1: json['streetAddress1'] as String,
        streetAddress2: json['streetAddress2'] as String,
        city: json['city'] as String,
        district: json['district'] as String,
        postalCode: json['postalCode'] as String,
        selectedCountry: country,
      );
    }
  }
}
