import 'package:flutter/material.dart';
import 'package:simple_kit/modules/buttons/basic_buttons/base/simple_base_button.dart';

class SimpleBaseTextButton extends StatefulWidget {
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
      nameColor: currentColor,
      decoration: BoxDecoration(
        color: currentBackgroundColor,
      ),
    );
  }
}
