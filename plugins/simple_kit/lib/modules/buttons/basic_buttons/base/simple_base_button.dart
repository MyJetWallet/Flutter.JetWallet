import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

final _baseButtonRadius = BorderRadius.circular(16.0);

class SimpleBaseButton extends StatelessWidget {
  const SimpleBaseButton({
    Key? key,
    this.icon,
    this.onTap,
    this.baseline = 33.5,
    this.borderColor,
    this.addPadding = false,
    this.autoSize = false,
    required this.onHighlightChanged,
    required this.decoration,
    required this.name,
    required this.nameColor,
  }) : super(key: key);

  final bool addPadding;
  final bool autoSize;
  final Widget? icon;
  final Function()? onTap;
  final double baseline;
  final Function(bool) onHighlightChanged;
  final BoxDecoration decoration;
  final String name;
  final Color nameColor;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      onHighlightChanged: onHighlightChanged,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      borderRadius: _baseButtonRadius,
      child: Ink(
        height: 56.0,
        decoration: decoration.copyWith(
          borderRadius: _baseButtonRadius,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
        ),
        child: Baseline(
          baseline: baseline,
          baselineType: TextBaseline.alphabetic,
          child: SPaddingH24(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Baseline(
                      baselineType: TextBaseline.alphabetic,
                      baseline: 23,
                      child: icon,
                    ),
                    const SpaceW10(),
                  ],
                  if (addPadding)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          child: autoSize
                              ? SizedBox(
                                width: MediaQuery.of(context).size.width - 132,
                                child: AutoSizeText(
                                  name,
                                  minFontSize: 4.0,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  strutStyle: const StrutStyle(
                                    height: 1.56,
                                    fontSize: 18.0,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w700,
                                  ),
                                  style: TextStyle(
                                    height: 1.56,
                                    fontSize: 18.0,
                                    fontFamily: 'Gilroy',
                                    fontWeight: FontWeight.w700,
                                    color: nameColor,
                                  ),
                                ),
                              )
                              : Text(
                            name,
                            style: sButtonTextStyle.copyWith(
                              color: nameColor,
                            ),
                          ),
                        ),
                        if (icon != null)
                          const SpaceH8(),
                      ],
                    )
                  else
                    Flexible(
                      child: autoSize
                          ? SizedBox(
                            width: MediaQuery.of(context).size.width - 132,
                            child: AutoSizeText(
                              name,
                              minFontSize: 4.0,
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              strutStyle: const StrutStyle(
                                height: 1.56,
                                fontSize: 18.0,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w700,
                              ),
                              style: TextStyle(
                                height: 1.56,
                                fontSize: 18.0,
                                fontFamily: 'Gilroy',
                                fontWeight: FontWeight.w700,
                                color: nameColor,
                              ),
                            ),
                          )
                          : Text(
                        name,
                        style: sButtonTextStyle.copyWith(
                          color: nameColor,
                        ),
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
