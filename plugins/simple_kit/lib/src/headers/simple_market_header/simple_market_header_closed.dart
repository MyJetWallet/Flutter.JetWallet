import 'package:flutter/material.dart';

import '../../../simple_kit.dart';
import 'components/simple_market_header_title.dart';

class SMarketHeaderClosed extends StatelessWidget {
  const SMarketHeaderClosed({
    Key? key,
    this.isDivider = false,
    required this.title,
    required this.onSearchButtonTap,
  }) : super(key: key);

  final bool isDivider;
  final String title;
  final Function() onSearchButtonTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SpaceH64(),
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
