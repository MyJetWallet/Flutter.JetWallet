import 'package:flutter/material.dart';
import 'package:simple_kit/modules/headers/simple_market_header/components/simple_market_header_title.dart';

import '../../../simple_kit.dart';

class SMarketHeaderClosed extends StatelessWidget {
  const SMarketHeaderClosed({
    Key? key,
    this.onSearchButtonTap,
    this.isDivider = false,
    required this.title,
  }) : super(key: key);

  final void Function()? onSearchButtonTap;
  final bool isDivider;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
