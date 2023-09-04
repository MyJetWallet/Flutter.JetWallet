import 'package:flutter/material.dart';
import 'package:simple_kit/modules/headers/simple_market_header/components/simple_market_header_filter.dart';

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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          children: [
            const SpaceH11(),
            Text(
              title,
              style: sTextH4Style,
            ),
          ],
        ),
        const Spacer(),
        if (onFilterButtonTap != null)
          SimpleMarketHeaderFilter(
            onFilterButtonTap: onFilterButtonTap,
            activeFilters: activeFilters,
          ),
        if (onSearchButtonTap != null) ...[
          Column(
            children: [
              const SpaceH11(),
              SizedBox(
                width: 56.0,
                height: 34.0,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SIconButton(
                      onTap: onSearchButtonTap,
                      defaultIcon: const SSearchIcon(),
                      pressedIcon: const SSearchPressedIcon(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SpaceW4(),
        ],
      ],
    );
  }
}
