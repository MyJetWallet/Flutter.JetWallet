import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../simple_kit.dart';

class SimpleSecurityCategoryButtonWithSwitch extends StatelessWidget {
  const SimpleSecurityCategoryButtonWithSwitch({
    Key? key,
    this.onTap,
    this.onSwitchChanged,
    this.switchValue = false,
    required this.isSDivider,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final Widget? icon;
  final bool switchValue;
  final Function()? onTap;
  final Function(bool)? onSwitchChanged;
  final String title;
  final bool isSDivider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SPaddingH24(
        child: Column(
          children: <Widget>[
            Container(
              height: 30.h,
              margin: EdgeInsets.symmetric(
                vertical: 18.h,
              ),
              child: Row(
                children: <Widget>[
                  icon!,
                  const SpaceW20(),
                  Text(
                    title,
                    style: sSubtitle1Style,
                  ),
                ],
              ),
            ),
            if (isSDivider)
              const SDivider(),
          ],
        ),
      ),
    );



    //   InkWell(
    //   onTap: onTap,
    //   child: Container(
    //     height: 30.h,
    //     margin: EdgeInsets.symmetric(
    //       vertical: 20.h,
    //     ),
    //     child: Row(
    //       children: [
    //         if (icon != null) ...[
    //           Icon(
    //             icon,
    //             size: 30.r,
    //           ),
    //           const SpaceW10(),
    //         ],
    //         Text(
    //           name,
    //           style: TextStyle(
    //             fontSize: 20.sp,
    //           ),
    //         ),
    //         const Spacer(),
    //         if (onSwitchChanged != null)
    //           Switch(
    //             value: switchValue,
    //             onChanged: onSwitchChanged,
    //             activeColor: Colors.white,
    //             activeTrackColor: Colors.blue,
    //             inactiveThumbColor: Colors.white,
    //             inactiveTrackColor: Colors.grey,
    //           )
    //       ],
    //     ),
    //   ),
    // );
  }
}