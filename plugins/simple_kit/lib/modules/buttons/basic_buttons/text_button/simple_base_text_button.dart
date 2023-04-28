import 'package:flutter/material.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/base/simple_base_button.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';

class SimpleBaseTextButton extends StatefulWidget {
  const SimpleBaseTextButton({
    Key? key,
    this.icon,
    this.addPadding = false,
    this.autoSize = false,
    required this.active,
    required this.name,
    required this.onTap,
    required this.activeColor,
    required this.activeBackgroundColor,
    required this.inactiveColor,
  }) : super(key: key);

  final Widget? icon;
  final bool active;
  final bool addPadding;
  final bool autoSize;
  final String name;
  final Function() onTap;
  final Color activeColor;
  final Color inactiveColor;
  final Color activeBackgroundColor;

  @override
  State<SimpleBaseTextButton> createState() => _SimpleBaseTextButtonState();
}

class _SimpleBaseTextButtonState extends State<SimpleBaseTextButton> {
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    late Color currentColor;
    late Color currentBackgroundColor;

    if (widget.active) {
      if (highlighted) {
        currentColor = widget.activeColor.withOpacity(0.8);
        currentBackgroundColor = widget.activeBackgroundColor;
      } else {
        currentColor = widget.activeColor;
        currentBackgroundColor = Colors.transparent;
      }
    } else {
      currentColor = widget.inactiveColor;
      currentBackgroundColor = Colors.transparent;
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
      addPadding: widget.addPadding,
      autoSize: widget.autoSize,
      nameColor: currentColor,
      decoration: BoxDecoration(
        color: currentBackgroundColor,
      ),
    );
  }
}
