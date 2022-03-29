import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../base/simple_base_button.dart';

class SimpleBaseTextButton extends HookWidget {
  const SimpleBaseTextButton({
    Key? key,
    required this.active,
    required this.name,
    required this.onTap,
    required this.activeColor,
    required this.activeBackgroundColor,
    required this.inactiveColor,
  }) : super(key: key);

  final bool active;
  final String name;
  final Function() onTap;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final highlighted = useState(false);

    late Color currentColor;
    late Color currentBackgroundColor;

    if (active) {
      if (highlighted.value) {
        currentColor = activeColor.withOpacity(0.8);
        currentBackgroundColor = activeBackgroundColor;
      } else {
        currentColor = activeColor;
        currentBackgroundColor = Colors.transparent;
      }
    } else {
      currentColor = inactiveColor;
      currentBackgroundColor = Colors.transparent;
    }

    return SimpleBaseButton(
      name: name,
      onTap: active ? onTap : null,
      onHighlightChanged: (value) {
        highlighted.value = value;
      },
      nameColor: currentColor,
      decoration: BoxDecoration(
          color: currentBackgroundColor,
      ),
    );
  }
}
