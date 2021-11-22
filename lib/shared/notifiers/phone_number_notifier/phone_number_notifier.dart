import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../logging/levels.dart';
import 'phone_number_state.dart';

class PhoneNumberNotifier extends StateNotifier<PhoneNumberState> {
  PhoneNumberNotifier() : super(const PhoneNumberState());

  static final _logger = Logger('PhoneNumberNotifier');

  final allCountriesCode = sPhoneNumbers;
  final _filteredCountriesCode = <SPhoneNumber>[];
  final filteredWithActiveCountryCode = <SPhoneNumber>[];

  List<SPhoneNumber> get filteredCountriesCode => _filteredCountriesCode;

  void updateValid({required bool valid}) {
    _logger.log(notifier, 'updateValid');

    state = state.copyWith(valid: valid);
  }

  void updatePhoneNumber(String? number) {
    _logger.log(notifier, 'updatePhoneNumber');

    state = state.copyWith(phoneNumber: number);
  }

  void updateCountryCode(String? code) {
    _logger.log(notifier, 'updateCountryCode');

    state = state.copyWith(countryCode: code);
  }

  void sortCountriesCode(String countryName) {
    _logger.log(notifier, 'sortCountries');

    final filteredList = <SPhoneNumber>[];

    for (final element in allCountriesCode) {
      final searchElement =
          element.countryName.toLowerCase().contains(countryName.toLowerCase());

      final searchElementCode =
          element.countryCode.toLowerCase().contains(countryName.toLowerCase());

      if (searchElement || searchElementCode) {
        filteredList.add(element);
      }
    }

    state = state.copyWith(filteredCountriesCode: filteredList);
  }

  void sortClearCountriesCode() {
    state = state.copyWith(filteredCountriesCode: []);
  }

  bool setActiveCode() {
    return state.countryCode != '' &&
        state.phoneNumber != null &&
        state.phoneNumber!.length > 5;
  }

  List<SPhoneNumber> sortActiveCountryCode() {
    var newList = <SPhoneNumber>[];

    if (state.countryCode != '') {
      final country = allCountriesCode.firstWhere(
        (country) => country.countryCode == state.countryCode,
      );
      final elementIndex = allCountriesCode.indexOf(country);

      newList = List<SPhoneNumber>.from(allCountriesCode);
      newList.removeAt(elementIndex);
      newList.insert(0, country);
    } else {
      newList = allCountriesCode;
    }
    return newList;
  }
}
