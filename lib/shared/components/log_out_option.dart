import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

import 'app_version_box.dart';

class LogOutOption extends HookWidget {
  const LogOutOption({
    Key? key,
    this.textColor = Colors.black,
    this.borderColor = Colors.black,
    required this.name,
    required this.onTap,
  }) : super(key: key);

  final Color textColor;
  final Color borderColor;
  final String name;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colors = useProvider(sColorPod);

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 30.h,
        margin: EdgeInsets.symmetric(
          vertical: 18.h,
          horizontal: 24.h,
        ),
        child: Row(
          children: <Widget>[
            const SLogOutIcon(),
            const SpaceW20(),
            Expanded(
              child: Text(
                name,
                style: sSubtitle1Style.copyWith(
                  color: colors.red,
                ),
              ),
            ),
            const AppVersionBox(),
          ],
        ),
      ),
    );
  }
}
