import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/typography/simple_typography.dart';

import '../../colors/simple_colors_light.dart';

class SITextButton extends StatefulWidget {
  const SITextButton({
    super.key,
    required this.name,
    required this.onTap,
    required this.active,
    this.icon,
  });

  final Function() onTap;
  final String name;
  final bool active;
  final Widget? icon;

  @override
  State<SITextButton> createState() => _SimpleInvestTextButtonState();
}

class _SimpleInvestTextButtonState extends State<SITextButton> {
  bool highlighted = false;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();
    late Color currentColor;
    late Color currentNameColor;

    if (widget.active) {
      currentNameColor = colors.blue;
      currentColor = highlighted ? colors.blueLight.withOpacity(0.8) : Colors.transparent;
    } else {
      currentColor = Colors.transparent;
      currentNameColor = colors.gray4;
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
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: currentColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  widget.name,
                  style: STStyles.body1InvestSM.copyWith(color: currentNameColor),
                ),
              ),
              const SizedBox(width: 4),
              if (widget.icon != null) widget.icon!,
            ],
          ),
        ),
      ),
    );
  }
}
