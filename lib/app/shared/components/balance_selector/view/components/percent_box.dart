import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PercentBox extends StatelessWidget {
  const PercentBox({
    Key? key,
    required this.name,
    required this.onTap,
    required this.enabled,
  }) : super(key: key);

  final String name;
  final Function() onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.r),
        child: Container(
          height: 40.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: enabled ? Colors.grey[400] : Colors.grey[200],
          ),
          child: Center(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
