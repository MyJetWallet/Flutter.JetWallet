import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/components/header_text.dart';
import '../../../../../../shared/components/spacers.dart';

class SendOptionCard extends StatelessWidget {
  const SendOptionCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title;
  final String description;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 115.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.all(
            Radius.circular(8.r),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 20.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: 20.r,
            ),
            const SpaceH8(),
            HeaderText(
              text: title,
              textAlign: TextAlign.start,
            ),
            const SpaceH8(),
            Text(
              description,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.black54,
              ),
            )
          ],
        ),
      ),
    );
  }
}
