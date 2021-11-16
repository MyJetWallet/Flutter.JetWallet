import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../provider/market_gainers_pod.dart';
import '../../../provider/market_loosers_pod.dart';
import 'components/market_tab.dart';

class MarketTabs extends HookWidget {
  const MarketTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);
    final gainers = useProvider(marketGainersPod);
    final loosers = useProvider(marketLoosersPod);

    return Container(
      color: Colors.white.withOpacity(0.4),
      height: 56.h,
      width: 375.w,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Padding(
            padding: EdgeInsets.only(
              left: 24.w,
              top: 10.h,
              bottom: 10.h,
            ),
            child: TabBar(
              indicator: BoxDecoration(
                color: colors.grey5,
                borderRadius: BorderRadius.all(
                  Radius.circular(24.r),
                ),
                border: Border.all(
                  width: 2.r,
                  color: colors.black,
                ),
              ),
              labelColor: colors.black,
              unselectedLabelColor: colors.grey1,
              unselectedLabelStyle: TextStyle(color: colors.grey1),
              isScrollable: true,
              tabs: [
                const MarketTab(text: 'All'),
                const MarketTab(text: 'Watchlist'),
                if (gainers.isNotEmpty) ...[
                  const MarketTab(text: 'Gainers'),
                ],
                if (loosers.isNotEmpty) ...[
                  const MarketTab(text: 'Loosers'),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
