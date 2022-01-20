import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../notifier/kyc_countries/kyc_countries_notipod.dart';

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
          'Country if Issue',
          style: sTextH2Style,
        ),
        SStandardField(
          autofocus: true,
          labelText: 'Search',
          onChanged: (value) {
            notifier.updateCountryNameSearch(value);
          },
        ),
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
    final colors = useProvider(sColorPod);
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        for (final country in state.sortedCountries)
          InkWell(
            highlightColor: colors.grey5,
            splashColor: Colors.transparent,
            onTap: () {
              notifier.pickCountryFromSearch(country);
              Navigator.pop(context);
            },
            child: SPaddingH24(
              child: SizedBox(
                height: 64.0,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 20.0,
                          ),
                          child: Container(
                            width: 24.0,
                            height: 24.0,
                            decoration: BoxDecoration(
                              color: colors.grey2,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                        ),
                        const SpaceW10(),
                        Baseline(
                          baseline: 38.0,
                          baselineType: TextBaseline.alphabetic,
                          child: Row(
                            children: [
                              const SpaceW10(),
                              SizedBox(
                                width: size.width - 160.0,
                                child: Text(
                                  country.countryName,
                                  style: sSubtitle2Style.copyWith(
                                    color: colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const SDivider()
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
