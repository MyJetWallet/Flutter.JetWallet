import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/prepaid_card/store/search_country_store.dart';
import 'package:jetwallet/widgets/action_bottom_sheet_header.dart';
import 'package:jetwallet/widgets/flag_item.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

void showChooseCountreBottomShet({
  required BuildContext context,
  void Function({
    required SPhoneNumber newCountry,
  })? onSelected,
  dynamic Function(dynamic)? then,
  required List<SPhoneNumber> countries,
}) {
  countries.sort((a, b) => a.countryName.compareTo(b.countryName));
  final store = SearchCountryStore(allCountries: ObservableList.of(countries));
  sShowBasicModalBottomSheet(
    context: context,
    then: then,
    scrollable: true,
    expanded: true,
    pinned: ActionBottomSheetHeader(
      name: intl.prepaid_card_choose_country,
      needBottomPadding: false,
      showSearch: true,
      onChanged: store.onSarch,
      horizontalDividerPadding: 24,
      addPaddingBelowTitle: true,
      isNewDesign: true,
    ),
    horizontalPinnedPadding: 0.0,
    removePinnedPadding: true,
    horizontalPadding: 0,
    children: [
      _PaymentMethodScreenBody(
        onSelected: onSelected,
        store: store,
      ),
    ],
  );
}

class _PaymentMethodScreenBody extends StatelessObserverWidget {
  const _PaymentMethodScreenBody({
    this.onSelected,
    required this.store,
  });

  final void Function({
    required SPhoneNumber newCountry,
  })? onSelected;
  final SearchCountryStore store;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          for (final country in store.searchedCountries)
            SPhoneCodes(
              iconFlag: FlagItem(
                countryCode: country.isoCode,
              ),
              country: country.countryName,
              onTap: () {
                onSelected?.call(newCountry: country);
              },
            ),
          const SpaceH45(),
        ],
      ),
    );
  }
}
