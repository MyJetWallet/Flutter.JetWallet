import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit/src/colors/view/simple_colors_light.dart';

import 'components/keyboard_key_detector.dart';
import 'components/keyboard_key_size.dart';

class KeyboardIcon extends HookWidget {
  const KeyboardIcon({
    this.hide,
    this.activeIcon,
    this.pressedIcon,
    required this.realValue,
    required this.onPressed,
  });

  final bool? hide;
  final Widget? activeIcon;
  final Widget? pressedIcon;

  /// The value that will be returned onPressed
  final String realValue;
  final void Function(String) onPressed;

  @override
  Widget build(BuildContext context) {
    final highlighted = useState(false);

    return KeyboardKeySize(
      child: hide ?? false
          ? const SizedBox()
          : Container(
              decoration: BoxDecoration(
                color: highlighted.value
                    ? SColorsLight().white
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
              ),
              child: KeyboardKeyDetector(
                onTap: () => onPressed(realValue),
                onHighlightChanged: (value) {
                  highlighted.value = value;
                },
                child: highlighted.value ? pressedIcon : activeIcon,
              ),
            ),
    );
  }
}
