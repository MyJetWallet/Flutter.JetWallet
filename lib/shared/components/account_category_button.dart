import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

class AccountCategoryButton extends HookWidget {
  const AccountCategoryButton({
    Key? key,
    this.onTap,
    this.icon,
    required this.title,
    required this.isBottomBorder,
  }) : super(key: key);

  final Widget? icon;
  final Function()? onTap;
  final String title;
  final bool isBottomBorder;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return Container(
      decoration: isBottomBorder ? BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: colors.grey4,
            width: 1.h,
          ),
        ),
      ) : BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 0.h,
            color: Colors.transparent,
          ),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 30.h,
          margin: EdgeInsets.symmetric(
            vertical: 18.h,
          ),
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(
                  right: 20.w,
                ),
                child: icon,
              ),
              Text(
                title,
                style: sSubtitle1Style,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
