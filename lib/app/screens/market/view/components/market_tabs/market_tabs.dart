import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'components/market_tab.dart';

class MarketTabs extends StatelessWidget implements PreferredSizeWidget {
  const MarketTabs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
        ),
        margin: EdgeInsets.only(bottom: 16.h),
        child: const TabBar(
          indicator: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          unselectedLabelColor: Colors.grey,
          isScrollable: true,
          tabs: [
            MarketTab(text: 'All'),
            MarketTab(text: 'Watchlist'),
            MarketTab(text: 'Gainers'),
            MarketTab(text: 'Loosers'),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(40.h);
}
