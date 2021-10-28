import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../simple_kit.dart';

class SimpleBaseLinkButton extends HookWidget {
  const SimpleBaseLinkButton({
    Key? key,
    required this.name,
    required this.onTap,
    required this.active,
    required this.activeColor,
    required this.inactiveColor,
    required this.defaultIcon,
    required this.pressedIcon,
    required this.inactiveIcon,
  }) : super(key: key);

  final String name;
  final Function() onTap;
  final bool active;
  final Color activeColor;
  final Color inactiveColor;
  final Widget defaultIcon;
  final Widget pressedIcon;
  final Widget inactiveIcon;

  @override
  Widget build(BuildContext context) {
    final highlighted = useState(false);

    late Color currentColor;
    late Widget currentIcon;

    if (active) {
      if (highlighted.value) {
        currentColor = activeColor.withOpacity(0.8);
        currentIcon = pressedIcon;
      } else {
        currentColor = activeColor;
        currentIcon = defaultIcon;
      }
    } else {
      currentColor = inactiveColor;
      currentIcon = inactiveIcon;
    }

    return InkWell(
      onTap: onTap,
      onHighlightChanged: (value) {
        highlighted.value = value;
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Ink(
        height: 56.h,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name,
                style: sButtonTextStyle.copyWith(
                  color: currentColor,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              currentIcon,
            ],
          ),
        ),
      ),
    );
  }
}
