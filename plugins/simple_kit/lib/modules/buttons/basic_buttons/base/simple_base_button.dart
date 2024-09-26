import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit/modules/shared/simple_paddings.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

final _baseButtonRadius = BorderRadius.circular(16.0);

class SimpleBaseButton extends StatefulWidget {
  const SimpleBaseButton({
    super.key,
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
    this.isLoading = false,
  });

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
  final bool isLoading;

  @override
  State<SimpleBaseButton> createState() => _SimpleBaseButtonState();
}

class _SimpleBaseButtonState extends State<SimpleBaseButton> {
  var isClicked = false;

  // ignore: unused_field
  late Timer _timer;

  void _startTimer() {
    _timer = Timer(const Duration(milliseconds: 999), () => isClicked = false);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap != null
          ? () {
              if (!isClicked) {
                _startTimer();
                widget.onTap!();
                isClicked = true;
              }
            }
          : null,
      onHighlightChanged: widget.onHighlightChanged,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      borderRadius: _baseButtonRadius,
      child: Ink(
        height: 56.0,
        decoration: widget.decoration.copyWith(
          borderRadius: _baseButtonRadius,
          border: widget.borderColor != null ? Border.all(color: widget.borderColor!) : null,
        ),
        child: widget.isLoading
            ? const Center(
                child: SizedBox(
                  height: 24.0,
                  width: 24.0,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              )
            : Baseline(
                baseline: widget.baseline,
                baselineType: TextBaseline.alphabetic,
                child: SPaddingH24(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Baseline(
                          baselineType: TextBaseline.alphabetic,
                          baseline: 23,
                          child: widget.icon,
                        ),
                        const SpaceW10(),
                      ],
                      if (widget.addPadding)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: widget.autoSize
                                  ? SizedBox(
                                      width: MediaQuery.of(context).size.width - 132,
                                      child: AutoSizeText(
                                        widget.name,
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
                                          color: widget.nameColor,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      widget.name,
                                      style: sButtonTextStyle.copyWith(
                                        color: widget.nameColor,
                                      ),
                                    ),
                            ),
                            if (widget.icon != null) const SpaceH8(),
                          ],
                        )
                      else
                        Flexible(
                          child: widget.autoSize
                              ? SizedBox(
                                  width: MediaQuery.of(context).size.width - 132,
                                  child: AutoSizeText(
                                    widget.name,
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
                                      color: widget.nameColor,
                                    ),
                                  ),
                                )
                              : Text(
                                  widget.name,
                                  style: sButtonTextStyle.copyWith(
                                    color: widget.nameColor,
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
