import 'package:flutter/material.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

final _baseButtonRadius = BorderRadius.circular(12.0);

class SIButton extends StatefulWidget {
  const SIButton({
    super.key,
    this.icon,
    this.borderColor,
    this.isSecondary = false,
    required this.active,
    required this.name,
    this.description,
    required this.onTap,
    required this.activeColor,
    required this.activeNameColor,
    required this.inactiveColor,
    required this.inactiveNameColor,
  });

  final Widget? icon;
  final bool active;
  final bool isSecondary;
  final String name;
  final String? description;
  final Function() onTap;
  final Color? borderColor;
  final Color activeColor;
  final Color activeNameColor;
  final Color inactiveColor;
  final Color inactiveNameColor;

  @override
  State<SIButton> createState() => _SimpleInvestButtonState();
}

class _SimpleInvestButtonState extends State<SIButton> {
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

    return InkWell(
      onTap: widget.onTap,
      onHighlightChanged: (value) {
        setState(() {
          highlighted = value;
        });
      },
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      borderRadius: _baseButtonRadius,
      child: Ink(
        height: widget.isSecondary ? 32.0 : 44.0,
        decoration: BoxDecoration(
          color: currentColor,
        ).copyWith(
          borderRadius: _baseButtonRadius,
          border: widget.borderColor != null ? Border.all(color: widget.borderColor!) : null,
        ),
        child: Baseline(
          baseline: widget.isSecondary
              ? 21.5
              : widget.description == null
                  ? 27.5
                  : 23,
          baselineType: TextBaseline.alphabetic,
          child: SPaddingH24(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: widget.isSecondary ? MainAxisSize.min : MainAxisSize.max,
              children: [
                if (widget.icon != null) ...[
                  widget.icon!,
                  const SpaceW4(),
                ],
                Flexible(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.name,
                        style: widget.isSecondary
                            ? sBody1InvestSMStyle.copyWith(
                                color: currentNameColor,
                              )
                            : sButtonTextInvestStyle.copyWith(
                                color: currentNameColor,
                              ),
                      ),
                      if (widget.description != null)
                        Text(
                          widget.description!,
                          style: sBody2InvestSMStyle.copyWith(
                            color: currentNameColor,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
