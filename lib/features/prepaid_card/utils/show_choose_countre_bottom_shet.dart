import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/features/phone_verification/utils/simple_number.dart';
import 'package:jetwallet/features/prepaid_card/store/search_country_store.dart';
import 'package:jetwallet/widgets/bottom_sheet_bar.dart';
import 'package:jetwallet/widgets/flag_item.dart';
import 'package:mobx/mobx.dart';

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
  showBasicBottomSheet(
    context: context,
    expanded: true,
    header: BasicBottomSheetHeaderWidget(
      title: intl.prepaid_card_choose_country,
      searchOptions: SearchOptions(
        hint: intl.actionBottomSheetHeader_search,
        onChange: store.onSarch,
      ),
    ),
    children: [
      _PaymentMethodScreenBody(
        onSelected: onSelected,
        store: store,
      ),
    ],
  ).then((v) {
    then?.call(v);
  });
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
