import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_kit/simple_kit.dart';

import 'components/market_banner.dart';

class MarketBannerList extends StatelessWidget {
  const MarketBannerList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: 24.w,
        ),
        children: const [
          MarketBanner(),
          SpaceW10(),
          MarketBanner(),
        ],
      ),
    );
  }
}
