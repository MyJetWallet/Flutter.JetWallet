import 'package:flutter/material.dart';

class SimpleCircleButton extends StatefulWidget {
  const SimpleCircleButton({
    super.key,
    this.onTap,
    this.pressedIcon,
    this.backgroundColor = Colors.black,
    this.height = 48,
    required this.defaultIcon,
  });

  final Function()? onTap;
  final Widget? pressedIcon;
  final Widget defaultIcon;
  final double height;

  final Color backgroundColor;

  @override
  State<SimpleCircleButton> createState() => _SimpleCircleButtonState();
}

class _SimpleCircleButtonState extends State<SimpleCircleButton> {
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    late Color currentColor;

    currentColor = highlighted ? widget.backgroundColor.withOpacity(0.8) : widget.backgroundColor;

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentColor,
      ),
      padding: const EdgeInsets.all(12),
      child: InkWell(
        onTap: widget.onTap,
        onHighlightChanged: (value) {
          setState(() {
            highlighted = value;
          });
        },
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: highlighted ? (widget.pressedIcon ?? widget.defaultIcon) : widget.defaultIcon,
      ),
    );
  }
}
