import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/simple_kit.dart';

class SITextButton extends StatefulObserverWidget {
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
    final colors = sKit.colors;
    late Color currentColor;
    late Color currentNameColor;

    if (widget.active) {
      currentNameColor = colors.blue;
      currentColor = highlighted ? colors.blueLight.withOpacity(0.8) : Colors.transparent;
    } else {
      currentColor = Colors.transparent;
      currentNameColor = colors.grey4;
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
                  style: sBody1InvestSMStyle.copyWith(color: currentNameColor),
                ),
              ),
              const SpaceW4(),
              if (widget.icon != null) widget.icon!,
            ],
          ),
        ),
      ),
    );
  }
}
