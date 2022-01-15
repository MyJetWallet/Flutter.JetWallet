import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../base/simple_base_button.dart';

class SimpleBasePrimaryButton extends HookWidget {
  const SimpleBasePrimaryButton({
    Key? key,
    this.icon,
    this.addIconPadding = true,
    required this.active,
    required this.name,
    required this.onTap,
    required this.activeColor,
    required this.activeNameColor,
    required this.inactiveColor,
    required this.inactiveNameColor,
  }) : super(key: key);

  final Widget? icon;
  final bool active;
  final String name;
  final Function() onTap;
  final Color activeColor;
  final Color activeNameColor;
  final Color inactiveColor;
  final Color inactiveNameColor;
  final bool addIconPadding;

  @override
  Widget build(BuildContext context) {
    final highlighted = useState(false);

    late Color currentColor;
    late Color currentNameColor;

    if (active) {
      if (highlighted.value) {
        currentColor = activeColor.withOpacity(0.8);
        currentNameColor = activeNameColor.withOpacity(0.8);
      } else {
        currentColor = activeColor;
        currentNameColor = activeNameColor;
      }
    } else {
      currentColor = inactiveColor;
      currentNameColor = inactiveNameColor;
    }

    return SimpleBaseButton(
      name: name,
      onTap: active ? onTap : null,
      onHighlightChanged: (value) {
        highlighted.value = value;
      },
      icon: icon,
      enableIconPadding: addIconPadding,
      nameColor: currentNameColor,
      decoration: BoxDecoration(
        color: currentColor,
      ),
    );
  }
}
