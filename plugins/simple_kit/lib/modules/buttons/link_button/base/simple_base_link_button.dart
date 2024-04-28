import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';

class SimpleBaseLinkButton extends StatefulWidget {
  const SimpleBaseLinkButton({
    super.key,
    required this.name,
    required this.onTap,
    required this.active,
    required this.activeColor,
    required this.inactiveColor,
    this.defaultIcon,
    this.pressedIcon,
    this.inactiveIcon,
    this.textStyle,
    this.mainAxisAlignment,
  });

  final String name;
  final Function() onTap;
  final bool active;
  final Color activeColor;
  final Color inactiveColor;
  final Widget? defaultIcon;
  final Widget? pressedIcon;
  final Widget? inactiveIcon;
  final TextStyle? textStyle;
  final MainAxisAlignment? mainAxisAlignment;

  @override
  State<SimpleBaseLinkButton> createState() => _SimpleBaseLinkButtonState();
}

class _SimpleBaseLinkButtonState extends State<SimpleBaseLinkButton> {
  bool highlighted = false;

  var isClicked = false;
  late Timer _timer;

  void _startTimer() {
    _timer = Timer(const Duration(milliseconds: 999), () => isClicked = false);
  }

  @override
  Widget build(BuildContext context) {
    late Color currentColor;
    Widget? currentIcon;

    if (widget.active) {
      if (highlighted) {
        currentColor = widget.activeColor.withOpacity(0.8);

        currentIcon = widget.pressedIcon;
      } else {
        currentColor = widget.activeColor;
        currentIcon = widget.defaultIcon;
      }
    } else {
      currentColor = widget.inactiveColor;
      currentIcon = widget.inactiveIcon;
    }

    return InkWell(
      onTap: widget.active
          ? () {
              if (!isClicked) {
                _startTimer();
                widget.onTap();
                isClicked = true;
              }
            }
          : null,
      onHighlightChanged: (value) {
        setState(() {
          highlighted = value;
        });
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: widget.mainAxisAlignment ?? MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 1),
              child: Text(
                widget.name,
                style: widget.textStyle != null
                    ? widget.textStyle!.copyWith(color: currentColor)
                    : sButtonTextStyle.copyWith(color: currentColor),
              ),
            ),
            const SpaceW4(),
            if (currentIcon != null) currentIcon,
          ],
        ),
      ),
    );
  }
}
