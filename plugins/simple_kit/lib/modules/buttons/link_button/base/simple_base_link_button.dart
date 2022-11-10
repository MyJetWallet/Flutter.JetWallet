import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';

class SimpleBaseLinkButton extends StatefulWidget {
  const SimpleBaseLinkButton({
    Key? key,
    required this.name,
    required this.onTap,
    required this.active,
    required this.activeColor,
    required this.inactiveColor,
    required this.defaultIcon,
    required this.pressedIcon,
    required this.inactiveIcon,
  }) : super(key: key);

  final String name;
  final Function() onTap;
  final bool active;
  final Color activeColor;
  final Color inactiveColor;
  final Widget defaultIcon;
  final Widget pressedIcon;
  final Widget inactiveIcon;

  @override
  State<SimpleBaseLinkButton> createState() => _SimpleBaseLinkButtonState();
}

class _SimpleBaseLinkButtonState extends State<SimpleBaseLinkButton> {
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    late Color currentColor;
    late Widget currentIcon;

    if (widget.active) {
      if (highlighted) {
        currentColor = widget.activeColor.withOpacity(0.8);
        currentIcon = widget.pressedIcon;
      } else {
        currentColor = widget.activeColor;
        currentIcon = widget.defaultIcon;
      }
    } else {
      currentColor = widget.inactiveColor;
      currentIcon = widget.inactiveIcon;
    }

    return InkWell(
      onTap: widget.active ? widget.onTap : null,
      onHighlightChanged: (value) {
        setState(() {
          highlighted = value;
        });
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Ink(
        height: 56.0,
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.name,
                style: sButtonTextStyle.copyWith(
                  color: currentColor,
                ),
              ),
              const SpaceW10(),
              currentIcon,
            ],
          ),
        ),
      ),
    );
  }
}
