import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class CountriesLoop extends HookWidget {
  const CountriesLoop({
    Key? key,
    required this.countries,
    required this.onTap,
    required this.activeCountryCode,
  }) : super(key: key);

  final List<SPhoneNumber> countries;
  final Function(SPhoneNumber country) onTap;
  final String activeCountryCode;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Column(
      children: [
        for (var country in countries)
          SPaddingH24(
            child: GestureDetector(
              onTap: () => onTap(country),
              child: Container(
                height: 64.0,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: colors.grey4,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24.0,
                      height: 24.0,
                      decoration: BoxDecoration(
                        color: colors.grey2,
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    const SpaceW10(),
                    Container(
                      height: 64.0,
                      width: 68.0,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        country.countryCode,
                        style: sSubtitle2Style.copyWith(
                          color: colors.grey3,
                        ),
                      ),
                    ),
                    const SpaceW10(),
                    Expanded(
                      child: Text(
                        country.countryName,
                        style: sSubtitle2Style.copyWith(
                          color: (activeCountryCode == country.countryCode)
                              ? colors.blue
                              : colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
