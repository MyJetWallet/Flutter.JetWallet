import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PercentBox extends StatelessWidget {
  const PercentBox({
    Key? key,
    required this.name,
    required this.onTap,
    required this.disabled,
  }) : super(key: key);

  final String name;
  final Function() onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: disabled
                ? Colors.grey[200]?.withOpacity(0.5)
                : Colors.grey[200],
          ),
          child: Center(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: disabled ? Colors.black.withOpacity(0.5) : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
