import 'package:flutter/material.dart';

class SIconButton extends StatefulWidget {
  const SIconButton({
    Key? key,
    this.onTap,
    this.pressedIcon,
    required this.defaultIcon,
  }) : super(key: key);

  final Function()? onTap;
  final Widget? pressedIcon;
  final Widget defaultIcon;

  @override
  State<SIconButton> createState() => _SIconButtonState();
}

class _SIconButtonState extends State<SIconButton> {
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHighlightChanged: (value) {
        setState(() {
          highlighted = value;
        });
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: highlighted ? (widget.pressedIcon ?? widget.defaultIcon) : widget.defaultIcon,
    );
  }
}
