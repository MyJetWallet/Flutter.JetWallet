import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../../../../shared/components/header_text.dart';

class EmptyPortfolioAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const EmptyPortfolioAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w,
      ),
      child: Column(
        children: [
          const Expanded(
            child: HeaderText(
              text: 'Balance',
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.h, bottom: 52.h),
            child: Text(
              '\$0',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 42.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(0.25.sh);
}
