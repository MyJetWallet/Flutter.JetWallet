import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../provider/market_gainers_pod.dart';
import '../../../provider/market_loosers_pod.dart';
import 'components/market_tab.dart';

class MarketTabs extends HookWidget implements PreferredSizeWidget {
  const MarketTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gainers = useProvider(marketGainersPod);
    final loosers = useProvider(marketLoosersPod);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
        ),
        margin: EdgeInsets.only(bottom: 16.h),
        child: TabBar(
          indicator: const BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          unselectedLabelColor: Colors.grey,
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
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(40.h);
}
