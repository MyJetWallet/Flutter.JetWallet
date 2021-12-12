import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// TODO(Vova): Delete when Wallet UI will be done
class BalanceFrame extends StatelessWidget {
  const BalanceFrame({
    Key? key,
    required this.child,
    required this.backgroundColor,
    required this.height,
  }) : super(key: key);

  final Widget child;
  final Color backgroundColor;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      child: Container(
        height: height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16.r),
            topRight: Radius.circular(16.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 24.w,
            vertical: 24.h,
          ),
          child: child,
        ),
      ),
    );
  }
}
