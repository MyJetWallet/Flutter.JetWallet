import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarketBanner extends StatelessWidget {
  const MarketBanner({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 327.w,
      decoration: BoxDecoration(
        color: const Color(0xFFE0EBFA),
        borderRadius: BorderRadius.circular(16.r),
      ),
    );
  }
}
