import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../notifiers/phone_number_notifier/phone_number_notipod.dart';
import 'phone_number_loop.dart';

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
    final statePhoneNumber = useProvider(phoneNumberNotipod);

    return CountriesLoop(
      activeCountryCode: statePhoneNumber.countryCode!,
      onTap: (SPhoneNumber country) => onTap(country),
      countries: statePhoneNumber.filteredCountriesCode.isNotEmpty
          ? statePhoneNumber.filteredCountriesCode
          : countriesCodeList,
    );
  }
}
