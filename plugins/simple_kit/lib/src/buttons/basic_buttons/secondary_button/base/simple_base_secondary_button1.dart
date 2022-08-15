import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../base/simple_base_button.dart';

class SimpleBaseSecondaryButton2 extends HookWidget {
  const SimpleBaseSecondaryButton2({
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
    late Color currentNameColor;
    late Color currentBackgroundColor;

    if (active) {
      if (highlighted.value) {
        currentNameColor = activeNameColor.withOpacity(0.8);
        currentBackgroundColor = activeBackgroundColor;
      } else {
        currentNameColor = activeNameColor;
        currentBackgroundColor = inactiveBackgroundColor;
      }
    } else {
      currentNameColor = inactiveNameColor;
      currentBackgroundColor = inactiveBackgroundColor;
    }

    return SimpleBaseButton(
      name: name,
      icon: icon,
      baseline: 37.0,
      onTap: active ? onTap : null,
      onHighlightChanged: (value) {
        highlighted.value = value;
      },
      nameColor: currentNameColor,
      decoration: BoxDecoration(
        color: currentBackgroundColor,
      ),
    );
  }
}
