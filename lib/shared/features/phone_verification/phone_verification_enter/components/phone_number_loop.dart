import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_kit/simple_kit.dart';

class CountriesLoop extends StatelessWidget {
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
    return Column(
      children: [
        for (var country in countries)
          SPaddingH24(
            child: GestureDetector(
              onTap: () => onTap(country),
              child: Container(
                height: 64.h,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      width: 1.h,
                      color: SColorsLight().grey4,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 24.r,
                      height: 24.r,
                      decoration: BoxDecoration(
                        color: SColorsLight().grey2,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    const SpaceW10(),
                    Container(
                      height: 64.h,
                      width: 68.w,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        country.countryCode,
                        style: sSubtitle2Style.copyWith(
                          color: SColorsLight().grey3,
                        ),
                      ),
                    ),
                    const SpaceW10(),
                    Expanded(
                      child: Text(
                        country.countryName,
                        style: sSubtitle2Style.copyWith(
                          color: (activeCountryCode == country.countryCode)
                              ? SColorsLight().blue
                              : SColorsLight().black,
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
