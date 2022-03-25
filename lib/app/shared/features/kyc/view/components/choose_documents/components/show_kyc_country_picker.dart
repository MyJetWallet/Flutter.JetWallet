import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../notifier/choose_documents/choose_documents_notipod.dart';
import '../../../../notifier/kyc_countries/kyc_countries_notipod.dart';
import '../../empty_state/empty_state.dart';
import 'country_item/country_item.dart';

void showKycCountryPicker(BuildContext context) {
  context.read(kycCountriesNotipod.notifier).initCountrySearch();

  sShowBasicModalBottomSheet(
    context: context,
    scrollable: true,
    pinned: const _SearchPinned(),
    expanded: true,
    removeBarPadding: true,
    removePinnedPadding: true,
    children: [
      const _Countries(),
      const SpaceH24(),
    ],
  );
}

class _SearchPinned extends HookWidget {
  const _SearchPinned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = useProvider(kycCountriesNotipod.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpaceH20(),
        Text(
          'Country of Issue',
          style: sTextH2Style,
        ),
        SStandardField(
          autofocus: true,
          labelText: 'Search',
          onChanged: (value) {
            notifier.updateCountryNameSearch(value);
          },
        ),
        const SDivider(),
      ],
    );
  }
}

class _Countries extends HookWidget {
  const _Countries({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(kycCountriesNotipod);
    final notifier = useProvider(kycCountriesNotipod.notifier);
    final chooseDocumentsNotifier =
        useProvider(chooseDocumentsNotipod.notifier);

    return Column(
      children: [
        for (final country in state.sortedCountries)
          CountryItem(
            onTap: () {
              notifier.pickCountryFromSearch(country);
              chooseDocumentsNotifier.updateDocuments();
              Navigator.pop(context);
            },
            countryCode: country.countryCode,
            countryName: country.countryName,
          ),
        if (state.sortedCountries.isEmpty) const EmptyState(),
      ],
    );
  }
}
