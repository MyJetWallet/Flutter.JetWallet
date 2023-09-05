import 'package:flutter/material.dart';

import '../../../../simple_kit.dart';

class SimpleBaseLinkText extends StatefulWidget {
  const SimpleBaseLinkText({
    Key? key,
    required this.name,
    required this.onTap,
    required this.active,
    required this.activeColor,
    required this.inactiveColor,
  }) : super(key: key);

  final String name;
  final Function() onTap;
  final bool active;
  final Color activeColor;
  final Color inactiveColor;

  @override
  State<SimpleBaseLinkText> createState() => _SimpleBaseLinkTextState();
}

class _SimpleBaseLinkTextState extends State<SimpleBaseLinkText> {
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    late Color currentColor;

    if (widget.active) {
      // ignore: prefer-conditional-expressions
      if (highlighted) {
        currentColor = widget.activeColor.withOpacity(0.8);
      } else {
        currentColor = widget.activeColor;
      }
    } else {
      currentColor = widget.inactiveColor;
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
      child: Text(
        widget.name,
        style: sSubtitle3Style.copyWith(color: currentColor),
      ),
    );
  }
}
