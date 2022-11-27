import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/headers/simple_market_header/components/simple_market_header_filter.dart';
import 'package:simple_kit/modules/icons/24x24/public/filter/simple_filter_icon.dart';

import '../../../../simple_kit.dart';

class SimpleMarketHeaderTitle extends StatelessWidget {
  const SimpleMarketHeaderTitle({
    Key? key,
    this.onSearchButtonTap,
    this.onFilterButtonTap,
    required this.title,
    this.activeFilters = 0,
  }) : super(key: key);

  final void Function()? onSearchButtonTap;
  final void Function()? onFilterButtonTap;
  final String title;
  final int activeFilters;

  @override
  Widget build(BuildContext context) {
    return Row(
      textBaseline: TextBaseline.alphabetic,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Baseline(
          baseline: 24.0,
          baselineType: TextBaseline.alphabetic,
          child: Text(
            title,
            style: sTextH2Style,
          ),
        ),
        const Spacer(),
        if (onSearchButtonTap != null)
          Baseline(
            baseline: 24.0,
            baselineType: TextBaseline.alphabetic,
            child: SIconButton(
              onTap: onSearchButtonTap,
              defaultIcon: const SSearchIcon(),
              pressedIcon: const SSearchPressedIcon(),
            ),
          ),
        if (onFilterButtonTap != null)
          SimpleMarketHeaderFilter(
            onFilterButtonTap: onFilterButtonTap,
            activeFilters: activeFilters,
          ),
        /*
        if (onFilterButtonTap != null)
          SizedBox(
            width: 35,
            height: 35,
            child: InkWell(
              onTap: onFilterButtonTap,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  const SFilterIcon(),
                  if (activeFilters != 0) ...[
                    Positioned(
                      right: 0,
                      bottom: 18,
                      child: Container(
                        margin: const EdgeInsets.only(
                          top: 6.0,
                          right: 6.0,
                        ),
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: SColorsLight().blue,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$activeFilters',
                          style: sBodyText1Style.copyWith(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: SColorsLight().white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
      */
      ],
    );
  }
}
