import 'package:flutter/material.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/base/simple_base_button.dart';

class SimpleBaseSecondaryButton extends StatefulWidget {
  const SimpleBaseSecondaryButton({
    super.key,
    this.icon,
    this.borderColor,
    required this.active,
    required this.name,
    required this.onTap,
    required this.activeColor,
    required this.activeNameColor,
    required this.activeBackgroundColor,
    required this.inactiveColor,
    required this.inactiveNameColor,
    required this.inactiveBackgroundColor,
  });

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
  final Color? borderColor;

  @override
  State<SimpleBaseSecondaryButton> createState() => _SimpleBaseSecondaryButtonState();
}

class _SimpleBaseSecondaryButtonState extends State<SimpleBaseSecondaryButton> {
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    late Color currentColor;
    late Color currentNameColor;
    late Color currentBackgroundColor;

    if (widget.active) {
      if (highlighted) {
        currentColor = widget.activeColor.withOpacity(0.8);
        currentNameColor = widget.activeNameColor.withOpacity(0.8);
        currentBackgroundColor = widget.activeBackgroundColor;
      } else {
        currentColor = widget.activeColor;
        currentNameColor = widget.activeNameColor;
        currentBackgroundColor = widget.inactiveBackgroundColor;
      }
    } else {
      currentColor = widget.inactiveColor;
      currentNameColor = widget.inactiveNameColor;
      currentBackgroundColor = widget.inactiveBackgroundColor;
    }

    return SimpleBaseButton(
      name: widget.name,
      icon: widget.icon,
      baseline: 32.0,
      onTap: widget.active ? widget.onTap : null,
      onHighlightChanged: (value) {
        setState(() {
          highlighted = value;
        });
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
