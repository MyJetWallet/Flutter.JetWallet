import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:openpgp/openpgp.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:uuid/uuid.dart';

import '../../../../../service/services/circle/model/add_card/add_card_request_model.dart';
import '../../../../../service/shared/models/server_reject_exception.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import 'enter_card_details_state.dart';

class EnterCardDetailsNotifier extends StateNotifier<EnterCardDetailsState> {
  EnterCardDetailsNotifier(this.read)
      : super(
          EnterCardDetailsState(
            loader: StackLoaderNotifier(),
          ),
        ) {
    _initState();
  }

  final Reader read;

  static final _logger = Logger('EnterCardDetailsNotifier');

  Future<void> _initState() async {
    state = state.copyWith(
      selectedCountry: sPhoneNumbers[0],
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

  Future<void> addCard() async {
    _logger.log(notifier, 'addCard');

    state.loader!.startLoading();

    try {
      final response = await read(circleServicePod).encryptionKey();

      final base64Decoded = base64Decode(response.encryptionKey);
      final utf8Decoded = utf8.decode(base64Decoded);
      final encrypted = await OpenPGP.encrypt(
        '{"number":"${state.cardNumber}","cvv": "${state.cvv}"}',
        utf8Decoded,
      );
      final utf8Encoded = utf8.encode(encrypted);
      final base64Encoded = base64Encode(utf8Encoded);

      final model = AddCardRequestModel(
        keyId: response.keyId,
        requestGuid: const Uuid().v4(),
        encryptedData: base64Encoded,
        cardName: state.cardNumber,
        billingName: state.cardholderName,
        billingCity: state.city,
        billingCountry: state.selectedCountry!.isoCode,
        billingLine1: state.streetAddress1,
        billingLine2: state.streetAddress2,
        billingDistrict: state.district,
        billingPostalCode: state.postalCode,
        expMonth: 10,
        expYear: 2024,
      );

      await read(circleServicePod).addCard(model);
    } on ServerRejectException catch (error) {
      read(sNotificationNotipod.notifier).showError(
        error.cause,
        id: 1,
      );
    } catch (error) {
      read(sNotificationNotipod.notifier).showError(
        'Something went wrong! Try again',
        id: 1,
      );
    } finally {
      state.loader!.finishLoading();
    }
  }

  void updateCardNumber(String cardNumber) {
    state = state.copyWith(cardNumber: cardNumber);
  }

  void updateCvv(String cvv) {
    state = state.copyWith(cvv: cvv);
  }

  void updateExpiryDate(String expiryDate) {
    // expiryDate = '10/24'

    state = state.copyWith(
      month: 10,
      year: 2024,
    );
  }

  void updateCardName(String cardName) {
    state = state.copyWith(cardName: cardName);
  }

  void updateCardholderName(String cardholderName) {
    state = state.copyWith(cardholderName: cardholderName);
  }

  void updateCity(String city) {
    state = state.copyWith(city: city);
  }

  void updateAddress1(String address) {
    state = state.copyWith(streetAddress1: address);
  }

  void updateAddress2(String address) {
    state = state.copyWith(streetAddress2: address);
  }

  void updateDistrict(String district) {
    state = state.copyWith(district: district);
  }

  void updatePostalCode(String postalCode) {
    state = state.copyWith(postalCode: postalCode);
  }
}
