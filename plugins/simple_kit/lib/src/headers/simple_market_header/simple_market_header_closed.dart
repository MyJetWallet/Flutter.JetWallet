import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';
import 'components/simple_market_header_title.dart';

class SMarketHeaderClosed extends StatelessWidget {
  const SMarketHeaderClosed({
    Key? key,
    required this.title,
    required this.onSearchButtonTap,
  }) : super(key: key);

  final String title;
  final Function() onSearchButtonTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 64.h,
          ),
          SPaddingH24(
            child: SimpleMarketHeaderTitle(
              title: title,
              onSearchButtonTap: onSearchButtonTap,
            ),
          ),
          const Spacer(),
          const SDivider()
        ],
      ),
    );
  }
}
