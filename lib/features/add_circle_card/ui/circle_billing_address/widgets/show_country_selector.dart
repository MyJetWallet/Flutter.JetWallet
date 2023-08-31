import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jetwallet/features/add_circle_card/store/add_circle_card_store.dart';
import 'package:jetwallet/widgets/flag_item.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../core/l10n/i10n.dart';

void showCountrySelector(BuildContext context) {
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
    return SStandardField(
      controller: TextEditingController(),
      autofocus: true,
      labelText: intl.showCountrySelector_searchCountry,
      onChanged: (value) {
        AddCircleCardStore.of(context).updateCountrySearch(value);
      },
    );
  }
}

class _Countries extends StatelessObserverWidget {
  const _Countries({super.key});

  @override
  Widget build(BuildContext context) {
    final store = AddCircleCardStore.of(context);

    return Column(
      children: [
        for (final country in store.filteredCountries)
          _CountryItem(
            country: country,
            active: store.selectedCountry?.isoCode == country.isoCode,
            onTap: () {
              store.pickCountry(country);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}

class _CountryItem extends StatelessObserverWidget {
  const _CountryItem({
    super.key,
    this.active = false,
    required this.country,
    required this.onTap,
  });

  final bool active;
  final SPhoneNumber country;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    return InkWell(
      highlightColor: colors.grey5,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: SPaddingH24(
        child: SizedBox(
          height: 64.0,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Baseline(
                      baseline: 43.0,
                      baselineType: TextBaseline.alphabetic,
                      child: FlagItem(
                        countryCode: country.isoCode,
                      ),
                    ),
                    const SpaceW10(),
                    Expanded(
                      child: Baseline(
                        baseline: 38.0,
                        baselineType: TextBaseline.alphabetic,
                        child: Text(
                          country.countryName,
                          style: sSubtitle2Style.copyWith(
                            color: active ? colors.blue : colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const SDivider(),
            ],
          ),
        ),
      ),
    );
  }
}
