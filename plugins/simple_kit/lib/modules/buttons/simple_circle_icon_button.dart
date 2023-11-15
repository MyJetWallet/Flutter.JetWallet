import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_kit/core/simple_kit.dart';

class SimpleCircleButton extends StatefulWidget {
  const SimpleCircleButton({
    super.key,
    this.onTap,
    this.pressedIcon,
    this.backgroundColor = Colors.black,
    this.height = 48,
    this.isDisabled = false,
    required this.defaultIcon,
  });

  final Function()? onTap;
  final Widget? pressedIcon;
  final Widget defaultIcon;
  final double height;
  final bool isDisabled;

  final Color backgroundColor;

  @override
  State<SimpleCircleButton> createState() => _SimpleCircleButtonState();
}

class _SimpleCircleButtonState extends State<SimpleCircleButton> {
  bool highlighted = false;

  var isClicked = false;
  late Timer _timer;

  void _startTimer() {
    _timer = Timer(const Duration(milliseconds: 999), () => isClicked = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    late Color currentColor;

    currentColor = widget.isDisabled
        ? colors.grey4
        : highlighted
            ? widget.backgroundColor.withOpacity(0.8)
            : widget.backgroundColor;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentColor,
      ),
      padding: const EdgeInsets.all(12),
      child: InkWell(
        onTap: !widget.isDisabled
            ? widget.onTap != null
                ? () {
                    if (!isClicked) {
                      _startTimer();
                      widget.onTap!();
                      isClicked = true;
                    }
                  }
                : null
            : null,
        onHighlightChanged: (value) {
          setState(() {
            highlighted = value;
          });
        },
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: highlighted ? (widget.pressedIcon ?? widget.defaultIcon) : widget.defaultIcon,
      ),
    );
  }
}
