import 'package:flutter/material.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

class SimpleCircleButton extends StatefulWidget {
  const SimpleCircleButton({
    super.key,
    this.onTap,
    this.pressedIcon,
    this.backgroundColor = Colors.black,
    this.isDisabled = false,
    required this.defaultIcon,
    required this.name,
  });

  final Function()? onTap;
  final Widget? pressedIcon;
  final Widget defaultIcon;
  final bool isDisabled;
  final String name;

  final Color backgroundColor;

  @override
  State<SimpleCircleButton> createState() => _SimpleCircleButtonState();
}

class _SimpleCircleButtonState extends State<SimpleCircleButton> {
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    late Color currentColor;

    currentColor = widget.isDisabled
        ? colors.grey4
        : highlighted
            ? widget.backgroundColor.withOpacity(0.8)
            : widget.backgroundColor;

    return Expanded(
      child: InkWell(
        onTap: !widget.isDisabled ? widget.onTap : null,
        onHighlightChanged: (value) {
          setState(() {
            highlighted = value;
          });
        },
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxHeight: 68,
            minWidth: 68,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentColor,
                ),
                padding: const EdgeInsets.all(12),
                child: highlighted ? (widget.pressedIcon ?? widget.defaultIcon) : widget.defaultIcon,
              ),
              Text(
                widget.name,
                style: sCaptionTextStyle.copyWith(
                  fontWeight: FontWeight.w600,
                  color: widget.isDisabled ? colors.grey2 : null,
                ),
                maxLines: 2,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
