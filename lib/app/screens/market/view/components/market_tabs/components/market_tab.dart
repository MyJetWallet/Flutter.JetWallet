import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MarketTab extends StatelessWidget {
  const MarketTab({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: 10.w,
      ),
      padding: EdgeInsets.symmetric(
        vertical: 6.h,
        horizontal: 16.w,
      ),
      child: Text(text),
    );
  }
}
