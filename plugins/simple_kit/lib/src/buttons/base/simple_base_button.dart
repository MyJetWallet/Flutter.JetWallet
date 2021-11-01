import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../simple_kit.dart';

final _baseButtonRadius = BorderRadius.circular(16.r);

class SimpleBaseButton extends StatelessWidget {
  const SimpleBaseButton({
    Key? key,
    this.onTap,
    required this.onHighlightChanged,
    required this.decoration,
    required this.name,
    required this.nameColor,
  }) : super(key: key);

  final Function()? onTap;
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
      borderRadius: _baseButtonRadius,
      child: Ink(
        height: 56.h,
        decoration: decoration.copyWith(
          borderRadius: _baseButtonRadius,
        ),
        child: Center(
          child: Text(
            name,
            style: sButtonTextStyle.copyWith(
              color: nameColor,
            ),
          ),
        ),
      ),
    );
  }
}
