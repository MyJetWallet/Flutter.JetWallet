import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

class SimpleSecurityCategoryButton extends StatelessWidget {
  const SimpleSecurityCategoryButton({
    Key? key,
    required this.icon,
    required this.title,
    required this.isSDivider,
    this.onSwitchChanged,
    this.switchValue = false,
    this.onTap,
  }) : super(key: key);

  final bool isSDivider;
  final Widget? icon;
  final bool switchValue;
  final Function()? onTap;
  final Function(bool)? onSwitchChanged;
  final String title;

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
                  Expanded(
                    child: Text(
                      title,
                      style: sSubtitle1Style,
                    ),
                  ),
                  Icon(
                    Icons.arrow_right,
                    size: 24.r,
                  )
                ],
              ),
            ),
            if (isSDivider)
              const SDivider(),
          ],
        ),
      ),
    );
  }
}

