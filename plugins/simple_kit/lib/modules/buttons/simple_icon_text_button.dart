import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

class SIconTextButton extends StatefulWidget {
  const SIconTextButton({
    super.key,
    required this.text,
    this.icon,
    this.rightIcon,
    required this.onTap,
    this.mainAxisSize = MainAxisSize.min,
    this.textStyle,
  });

  final String text;
  final Widget? icon;
  final Widget? rightIcon;
  final void Function() onTap;
  final MainAxisSize mainAxisSize;
  final TextStyle? textStyle;

  @override
  State<SIconTextButton> createState() => _SIconTextButtonState();
}

class _SIconTextButtonState extends State<SIconTextButton> {
  var isClicked = false;
  late Timer _timer;

  void _startTimer() {
    _timer = Timer(const Duration(milliseconds: 999), () => isClicked = false);
  }

  @override
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    TextStyle? tStyle = sTextButtonStyle.copyWith(
      color: sKit.colors.blue,
      height: 1.5,
    );
    if (widget.textStyle != null) {
      tStyle = widget.textStyle!;
    }

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: colors.grey5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.only(
          left: 16,
          right: 20,
          top: 8,
          bottom: 8,
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ).copyWith(
        overlayColor: MaterialStateProperty.all(colors.grey4),
      ),
      onPressed: () {
        if (!isClicked) {
          _startTimer();
          widget.onTap();
          isClicked = true;
        }
      },
      child: Row(
        mainAxisSize: widget.mainAxisSize,
        children: [
          if (widget.icon != null) ...[
            widget.icon!,
            const SpaceW8(),
          ],
          Text(
            widget.text,
            style: tStyle,
          ),
          if (widget.rightIcon != null) ...[
            const Spacer(),
            widget.rightIcon!,
          ],
        ],
      ),
    );
  }
}
