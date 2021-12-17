import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../notifiers/phone_number_notifier/phone_number_notipod.dart';

class PhoneNumberBottomSheet extends HookWidget {
  const PhoneNumberBottomSheet({
    Key? key,
    required this.onTap,
    required this.countriesCodeList,
  }) : super(key: key);

  final List<SPhoneNumber> countriesCodeList;
  final Function(SPhoneNumber country) onTap;

  @override
  Widget build(BuildContext context) {
    final state = useProvider(phoneNumberNotipod);
    final countries = state.filteredCountriesCode.isNotEmpty
        ? state.filteredCountriesCode
        : countriesCodeList;

    return Column(
      children: [
        for (var dialCode in countries)
          SDialCodeItem(
            dialCode: dialCode,
            active: state.countryCode == dialCode.countryCode,
            onTap: () => onTap(dialCode),
          ),
      ],
    );
  }
}
