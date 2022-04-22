import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../base/simple_base_button.dart';

class SimpleBaseSecondaryButton extends HookWidget {
  const SimpleBaseSecondaryButton({
    Key? key,
    this.icon,
    required this.active,
    required this.name,
    required this.onTap,
    required this.activeColor,
    required this.activeNameColor,
    required this.activeBackgroundColor,
    required this.inactiveColor,
    required this.inactiveNameColor,
    required this.inactiveBackgroundColor,
  }) : super(key: key);

  final Widget? icon;
  final bool active;
  final String name;
  final Function() onTap;
  final Color activeColor;
  final Color activeNameColor;
  final Color activeBackgroundColor;
  final Color inactiveColor;
  final Color inactiveNameColor;
  final Color inactiveBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final highlighted = useState(false);

    late Color currentColor;
    late Color currentNameColor;
    late Color currentBackgroundColor;

    if (active) {
      if (highlighted.value) {
        currentColor = activeColor.withOpacity(0.8);
        currentNameColor = activeNameColor.withOpacity(0.8);
        currentBackgroundColor = activeBackgroundColor;
      } else {
        currentColor = activeColor;
        currentNameColor = activeNameColor;
        currentBackgroundColor = inactiveBackgroundColor;
      }
    } else {
      currentColor = inactiveColor;
      currentNameColor = inactiveNameColor;
      currentBackgroundColor = inactiveBackgroundColor;
    }

    return SimpleBaseButton(
      name: name,
      icon: icon,
      onTap: active ? onTap : null,
      onHighlightChanged: (value) {
        highlighted.value = value;
      },
      nameColor: currentNameColor,
      decoration: BoxDecoration(
        border: Border.all(
          color: currentColor,
          width: 2.0,
        ),
        color: currentBackgroundColor,
      ),
    );
  }
}
