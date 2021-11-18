import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../notifiers/enter_phone_notifier/enter_phone_notipod.dart';
import 'phone_number_loop.dart';
import 'phone_number_search.dart';


class PhoneNumberBottomSheet extends HookWidget {
  const PhoneNumberBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _countriesList = useState(sPhoneNumbers);
    final _filterCountriesList = useState(<SPhoneNumber>[]);

    final notifier = useProvider(enterPhoneNotipod.notifier);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: PhoneNumberSearch(
            onChange: (String number) {
              if (number.length > 1) {
                final filteredList = <SPhoneNumber>[];
                for (final element in _countriesList.value) {
                  final searchElement = element.countryName
                      .toLowerCase()
                      .contains(number.toLowerCase());

                  if (searchElement) {
                    filteredList.add(element);
                  }
                }
                final newList = List<SPhoneNumber>.from(filteredList);
                _filterCountriesList.value = newList;
              } else {
                _filterCountriesList.value = List<SPhoneNumber>.from(
                  _countriesList.value,
                );
              }
            },
          ),
        ),
        const SDivider(),
        CountriesLoop(
          onTap: (SPhoneNumber country) {
            notifier.updateIsoCode(country.countryCode);
            Navigator.of(context).pop();
          },
          countries: _filterCountriesList.value.isNotEmpty
              ? _filterCountriesList.value
              : _countriesList.value,
        ),
      ],
    );
  }
}
