import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/components/spacers.dart';

class SecurityProtection extends StatelessWidget {
  const SecurityProtection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F8),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          Icon(
            Icons.shield,
            size: 46.r,
            color: Colors.green,
          ),
          const SpaceH10(),
          Text(
            'Hardcoded protection level',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
