import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../shared/components/spacers.dart';

class SecurityOption extends HookWidget {
  const SecurityOption({
    Key? key,
    this.onTap,
    this.onSwitchChanged,
    this.switchValue = false,
    required this.name,
    required this.icon,
  }) : super(key: key);

  final bool switchValue;
  final Function()? onTap;
  final Function(bool)? onSwitchChanged;
  final String name;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 30.h,
        margin: EdgeInsets.symmetric(
          vertical: 20.h,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 30.r,
            ),
            const SpaceW10(),
            Text(
              name,
              style: TextStyle(
                fontSize: 20.sp,
              ),
            ),
            const Spacer(),
            if (onSwitchChanged != null)
              Switch(
                value: switchValue,
                onChanged: onSwitchChanged,
                activeColor: Colors.white,
                activeTrackColor: Colors.blue,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Colors.grey,
              )
            else
              Icon(
                Icons.arrow_right,
                size: 24.r,
              )
          ],
        ),
      ),
    );
  }
}
