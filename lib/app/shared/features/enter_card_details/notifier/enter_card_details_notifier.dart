import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:openpgp/openpgp.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:uuid/uuid.dart';

import '../../../../../service/services/circle/model/add_card/add_card_request_model.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import 'enter_card_details_state.dart';

class EnterCardDetailsNotifier extends StateNotifier<EnterCardDetailsState> {
  EnterCardDetailsNotifier(this.read) : super(const EnterCardDetailsState()) {
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

    final response = await read(circleServicePod).encryptionKey();

    final encryptedData = await OpenPGP.encrypt(
      '[{"number":"${state.cardNumber}","cvv": "${state.cvv}"}]',
      response.encryptionKey,
    );

    final model = AddCardRequestModel(
      keyId: response.keyId,
      requestGuid: const Uuid().v4(),
      encryptedData: encryptedData,
      cardName: state.cardNumber,
      billingName: state.cardholderName,
      billingCity: state.city,
      billingCountry: state.selectedCountry!.isoCode,
      billingLine1: state.streetAddress1,
      billingLine2: state.streetAddress2,
      billingDistrict: state.district,
      billingPostalCode: state.postalCode,
      expMonth: 10,
      expYear: 24,
    );

    try {
      await read(circleServicePod).addCard(model);
    } catch (e) {
      read(sNotificationNotipod.notifier).showError(
        'Wrong credentials! Try again',
        id: 1,
      );
    }
  }

  void updateCardNumber() {}
  void updateCvv() {}
  void updateExpiryDate() {}
  void updateBillingName() {}
  void updateBillingCity() {}
  void updateBillingLine1() {}
  void updateBillingLine2() {}
  void updateBillingDistrict() {}
  void updateBillingPostalCode() {}
}
