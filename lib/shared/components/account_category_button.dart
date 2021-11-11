import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_kit/simple_kit.dart';

class AccountCategoryButton extends HookWidget {
  const AccountCategoryButton({
    Key? key,
    this.onTap,
    required this.icon,
    required this.title,
    required this.isSDivider,
  }) : super(key: key);

  final Widget icon;
  final Function()? onTap;
  final String title;
  final bool isSDivider;

  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,
      child: Column(
        children: <Widget>[
          Container(
            height: 30.h,
            margin: EdgeInsets.symmetric(
              vertical: 18.h,
            ),
            child: Row(
              children: <Widget>[
                icon,
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
    );
  }
}
