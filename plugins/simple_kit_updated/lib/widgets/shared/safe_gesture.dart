// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

class SafeGesture extends StatefulWidget {
  const SafeGesture({
    super.key,
    required this.child,
    this.onTap,
    this.intervalMs = 500,
    this.highlightColor,
    this.radius,
    this.onHighlightChanged,
  });

  final Widget child;
  final GestureTapCallback? onTap;
  final int intervalMs;
  final Color? highlightColor;
  final double? radius;

  final Function(bool)? onHighlightChanged;

  @override
  _SafeGestureState createState() => _SafeGestureState();
}

class _SafeGestureState extends State<SafeGesture> {
  int lastTimeClicked = 0;
  Color hColor = SColorsLight().gray2;

  @override
  void initState() {
    if (widget.highlightColor != null) {
      hColor = widget.highlightColor!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap != null
          ? () {
              final now = DateTime.now().millisecondsSinceEpoch;
              if (now - lastTimeClicked < widget.intervalMs) {
                return;
              }

              lastTimeClicked = now;
              widget.onTap!();
            }
          : null,
      onHighlightChanged: widget.onHighlightChanged,
      borderRadius: widget.radius != null ? BorderRadius.circular(widget.radius!) : null,
      highlightColor: hColor,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      child: widget.child,
    );
  }
}
