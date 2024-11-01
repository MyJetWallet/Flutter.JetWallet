import 'package:flutter/material.dart';
import 'package:simple_kit/modules/headers/simple_market_header/components/simple_market_header_title.dart';

import '../../../simple_kit.dart';

class SMarketHeaderClosed extends StatelessWidget {
  const SMarketHeaderClosed({
    super.key,
    this.onSearchButtonTap,
    this.isDivider = false,
    this.color,
    required this.title,
  });

  final void Function()? onSearchButtonTap;
  final bool isDivider;
  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: 120.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH53(),
          SPaddingH24(
            child: SimpleMarketHeaderTitle(
              title: title,
              onSearchButtonTap: onSearchButtonTap,
            ),
          ),
          const Spacer(),
          if (isDivider) const SDivider(),
        ],
      ),
    );
  }
}
