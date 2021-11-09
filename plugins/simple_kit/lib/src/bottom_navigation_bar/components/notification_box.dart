import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class NotificationBox extends StatelessWidget {
  const NotificationBox({
    Key? key,
    required this.notifications,
  }) : super(key: key);

  final int notifications;

  @override
  Widget build(BuildContext context) {
    var text = '$notifications';

    if (notifications >= 100) text = '99+';

    if (notifications == 0) {
      return const SizedBox();
    } else {
      return Positioned(
        right: 0,
        child: Container(
          margin: EdgeInsets.only(
            top: 6.r,
            right: 6.r,
          ),
          child: Container(
            padding: EdgeInsets.all(2.r),
            decoration: BoxDecoration(
              color: SColorsLight().white,
              borderRadius: BorderRadius.circular(18.r),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 18.r,
                minHeight: 18.r,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: SColorsLight().blue,
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 3.4.r,
                  ),
                  child: Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: SColorsLight().white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
