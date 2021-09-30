import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangeNumberButton extends StatelessWidget {
  const ChangeNumberButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pop(context),
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: 140.w,
        height: 26.h,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey,
            width: 1.5.w,
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Center(
          child: Text(
            'Change number',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.black54,
            ),
          ),
        ),
      ),
    );
  }
}
