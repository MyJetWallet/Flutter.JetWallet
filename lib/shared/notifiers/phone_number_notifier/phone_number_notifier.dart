import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../logging/levels.dart';
import 'phone_number_state.dart';

class PhoneNumberNotifier extends StateNotifier<PhoneNumberState> {
  PhoneNumberNotifier()
      : super(
          PhoneNumberState(
            activeDialCode: sPhoneNumbers[0],
            dialCodeController: TextEditingController(
              text: sPhoneNumbers[0].countryCode,
            ),
            phoneNumberController: TextEditingController(),
          ),
        );

  static final _logger = Logger('PhoneNumberNotifier');

  void updatePhoneNumber(String? number) {
    _logger.log(notifier, 'updatePhoneNumber');

    state = state.copyWith(phoneNumber: number);
  }

  void updateCountryCode(String? code) {
    _logger.log(notifier, 'updateCountryCode');

    state = state.copyWith(countryCode: code);
  }

  void initDialCodeSearch() {
    updateDialCodeSearch('');
  }

  void updateDialCodeSearch(String dialCodeSearch) {
    _logger.log(notifier, 'updateDialCodeSearch');

    state = state.copyWith(dialCodeSearch: dialCodeSearch);

    _filterByDialCodeSearch();
  }

  void _filterByDialCodeSearch() {
    final newList = List<SPhoneNumber>.from(sPhoneNumbers);

    newList.removeWhere((element) {
      return !_isDialCodeInSearch(element);
    });

    state = state.copyWith(sortedDialCodes: List.from(newList));
  }

  bool _isDialCodeInSearch(SPhoneNumber number) {
    final search = state.dialCodeSearch.toLowerCase().replaceAll(' ', '');
    final code = number.countryCode.toLowerCase().replaceAll(' ', '');
    final name = number.countryName.toLowerCase().replaceAll(' ', '');

    return code.contains(search) || name.contains(search);
  }

  void pickDialCodeFromSearch(SPhoneNumber code) {
    state.dialCodeController.text = code.countryCode;
    updateActiveDialCode(code);
  }

  void updateActiveDialCode(SPhoneNumber? number) {
    state = state.copyWith(activeDialCode: number);
  }
}
