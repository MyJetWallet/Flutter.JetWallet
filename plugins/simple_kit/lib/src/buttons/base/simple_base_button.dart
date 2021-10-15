import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../texts/simple_button_text.dart';

final sBaseButtonRadius = BorderRadius.circular(16.r);

class SimpleBaseButton extends StatelessWidget {
  const SimpleBaseButton({
    Key? key,
    required this.onTap,
    required this.onHighlightChanged,
    required this.decoration,
    required this.name,
    required this.nameColor,
  }) : super(key: key);

  final Function() onTap;
  final Function(bool) onHighlightChanged;
  final BoxDecoration decoration;
  final String name;
  final Color nameColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onHighlightChanged: onHighlightChanged,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      borderRadius: sBaseButtonRadius,
      child: Ink(
        width: 327.w,
        height: 56.h,
        decoration: decoration.copyWith(
          borderRadius: sBaseButtonRadius,
        ),
        child: Center(
          child: SButtonText(
            text: name,
            color: nameColor,
          ),
        ),
      ),
    );
  }
}
