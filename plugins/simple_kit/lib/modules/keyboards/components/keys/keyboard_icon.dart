import 'package:flutter/material.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

import 'components/keyboard_key_detector.dart';
import 'components/keyboard_key_size.dart';

class KeyboardIcon extends StatefulWidget {
  const KeyboardIcon({
    Key? key,
    this.hide,
    this.activeIcon,
    this.pressedIcon,
    required this.realValue,
    required this.onPressed,
  }) : super(key: key);

  final bool? hide;
  final Widget? activeIcon;
  final Widget? pressedIcon;

  /// The value that will be returned onPressed
  final String realValue;
  final void Function(String) onPressed;

  @override
  State<KeyboardIcon> createState() => _KeyboardIconState();
}

class _KeyboardIconState extends State<KeyboardIcon> {
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    return KeyboardKeySize(
      child: widget.hide ?? false
          ? const SizedBox()
          : DecoratedBox(
              decoration: ShapeDecoration(
                color: !highlighted ? SColorsLight().white : SColorsLight().grey5,
                shape: const CircleBorder(),
              ),
              child: KeyboardKeyDetector(
                onTap: () => widget.onPressed(widget.realValue),
                onHighlightChanged: (value) {
                  setState(() {
                    highlighted = value;
                  });
                },
                child: highlighted ? widget.pressedIcon : widget.activeIcon,
              ),
            ),
    );
  }
}
