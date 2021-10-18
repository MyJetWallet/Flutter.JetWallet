import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../../shared/components/spacers.dart';

class PhoneCard extends StatelessWidget {
  const PhoneCard({
    Key? key,
    required this.phoneNumber,
    required this.name,
  }) : super(key: key);

  final String phoneNumber;
  final String? name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 4.h,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 10.w,
          vertical: 8.h,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[600]!,
          ),
          borderRadius: BorderRadius.circular(6.r),
        ),
        child: Row(
          children: [
            Icon(
              FontAwesomeIcons.mobileAlt,
              size: 26.r,
            ),
            const SpaceW16(),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? phoneNumber,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (name != null)
                    Text(
                      phoneNumber,
                      style: TextStyle(
                        fontSize: 12.sp,
                      ),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
