import 'package:flutter/material.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/base/simple_base_button.dart';

class SimpleBasePrimaryButton extends StatefulWidget {
  const SimpleBasePrimaryButton({
    super.key,
    this.icon,
    required this.active,
    required this.name,
    required this.onTap,
    required this.activeColor,
    required this.activeNameColor,
    required this.inactiveColor,
    required this.inactiveNameColor,
  });

  final Widget? icon;
  final bool active;
  final String name;
  final Function() onTap;
  final Color activeColor;
  final Color activeNameColor;
  final Color inactiveColor;
  final Color inactiveNameColor;

  @override
  State<SimpleBasePrimaryButton> createState() => _SimpleBasePrimaryButtonState();
}

class _SimpleBasePrimaryButtonState extends State<SimpleBasePrimaryButton> {
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    late Color currentColor;
    late Color currentNameColor;

    if (widget.active) {
      if (highlighted) {
        currentColor = widget.activeColor.withOpacity(0.8);
        currentNameColor = widget.activeNameColor.withOpacity(0.8);
      } else {
        currentColor = widget.activeColor;
        currentNameColor = widget.activeNameColor;
      }
    } else {
      currentColor = widget.inactiveColor;
      currentNameColor = widget.inactiveNameColor;
    }

    return SimpleBaseButton(
      name: widget.name,
      onTap: widget.active ? widget.onTap : null,
      onHighlightChanged: (value) {
        setState(() {
          highlighted = value;
        });
      },
      icon: widget.icon,
      nameColor: currentNameColor,
      decoration: BoxDecoration(
        color: currentColor,
      ),
    );
  }
}
