import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

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
    this.isLoading = true,
  });

  final Function()? onTap;
  final Widget? pressedIcon;
  final Widget defaultIcon;
  final bool isDisabled;
  final String name;
  final bool isExpanded;

  final Color backgroundColor;

  final bool isLoading;

  @override
  State<SimpleCircleButton> createState() => _SimpleCircleButtonState();
}

class _SimpleCircleButtonState extends State<SimpleCircleButton> {
  bool highlighted = false;

  var isClicked = false;
  // ignore: unused_field
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
          maxHeight: 76,
          minWidth: 76,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 48,
              width: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentColor,
              ),
              padding: const EdgeInsets.all(12),
              child: highlighted ? (widget.pressedIcon ?? widget.defaultIcon) : widget.defaultIcon,
            ),
            Text(
              widget.name,
              style: sCaptionTextStyle.copyWith(
                fontWeight: FontWeight.w600,
                color: widget.isDisabled ? colors.grey2 : null,
              ),
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
