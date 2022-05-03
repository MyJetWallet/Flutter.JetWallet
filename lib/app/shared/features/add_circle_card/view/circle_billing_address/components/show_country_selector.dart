import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../components/flag_item.dart';
import '../../../notifier/add_circle_card_notipod.dart';

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

class _SearchPinned extends HookWidget {
  const _SearchPinned({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notifier = useProvider(addCircleCardNotipod.notifier);

    return SStandardField(
      autofocus: true,
      labelText: 'Search country',
      onChanged: (value) {
        notifier.updateCountrySearch(value);
      },
    );
  }
}

class _Countries extends HookWidget {
  const _Countries({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = useProvider(addCircleCardNotipod);
    final notifier = useProvider(addCircleCardNotipod.notifier);

    return Column(
      children: [
        for (final country in state.filteredCountries)
          _CountryItem(
            country: country,
            active: state.selectedCountry?.isoCode == country.isoCode,
            onTap: () {
              notifier.pickCountry(country);
              Navigator.pop(context);
            },
          ),
      ],
    );
  }
}

class _CountryItem extends HookWidget {
  const _CountryItem({
    Key? key,
    this.active = false,
    required this.country,
    required this.onTap,
  }) : super(key: key);

  final bool active;
  final SPhoneNumber country;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

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
              const SDivider()
            ],
          ),
        ),
      ),
    );
  }
}
