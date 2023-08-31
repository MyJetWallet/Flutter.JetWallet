import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/kyc/choose_documents/store/choose_documents_store.dart';
import 'package:jetwallet/features/kyc/choose_documents/store/kyc_country_store.dart';
import 'package:jetwallet/widgets/empty_search_result.dart';
import 'package:simple_kit/simple_kit.dart';

import 'country_item/country_item.dart';

void showKycCountryPicker(BuildContext context) {
  getIt.get<KycCountryStore>().initCountrySearch();

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

class _SearchPinned extends StatelessObserverWidget {
  const _SearchPinned({super.key});

  @override
  Widget build(BuildContext context) {
    final store = getIt.get<KycCountryStore>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SpaceH20(),
        Text(
          intl.kycCountry_countryOfIssue,
          style: sTextH2Style,
        ),
        SStandardField(
          controller: TextEditingController(),
          autofocus: true,
          labelText: intl.showKycCountryPicker_search,
          onChanged: (value) {
            store.updateCountryNameSearch(value);
          },
        ),
        const SDivider(),
      ],
    );
  }
}

class _Countries extends StatelessObserverWidget {
  const _Countries({super.key});

  @override
  Widget build(BuildContext context) {
    final store = getIt.get<KycCountryStore>();
    final chooseDocumentsNotifier = getIt.get<ChooseDocumentsStore>();

    return Column(
      children: [
        for (final country in store.sortedCountries)
          CountryItem(
            onTap: () {
              store.pickCountryFromSearch(country);
              chooseDocumentsNotifier.updateDocuments();
              Navigator.pop(context);
            },
            countryCode: country.countryCode,
            countryName: country.countryName,
          ),
        if (store.sortedCountries.isEmpty)
          EmptySearchResult(
            text: store.countryNameSearch,
          ),
      ],
    );
  }
}
