import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';
import 'dart:async';

import 'package:flutter/material.dart';

class SimpleCircleButton extends StatefulWidget {
  const SimpleCircleButton({
    super.key,
    this.onTap,
    this.pressedIcon,
    this.backgroundColor = Colors.black,
    this.isDisabled = false,
    this.isExpanded = true,
    required this.defaultIcon,
    required this.name,
  });

  final Function()? onTap;
  final Widget? pressedIcon;
  final Widget defaultIcon;
  final bool isDisabled;
  final String name;
  final bool isExpanded;

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
    late Color currentColor;

    currentColor = widget.isDisabled
        ? SColorsLight().grayAlfa
        : highlighted
            ? SColorsLight().gray10
            : SColorsLight().black;

    final button = InkWell(
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
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxHeight: 68,
          minWidth: 68,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentColor,
              ),
              padding: const EdgeInsets.all(12),
              child: highlighted ? (widget.pressedIcon ?? widget.defaultIcon) : widget.defaultIcon,
            ),
            Text(
              widget.name,
              style: STStyles.captionSemibold,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    if (widget.isExpanded) {
      return Expanded(child: button);
    }

    return SizedBox(
      width: 80,
      child: button,
    );
  }
}
