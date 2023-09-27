import 'package:flutter/material.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/modules/shared/simple_spacers.dart';
import 'package:simple_kit/modules/texts/simple_text_styles.dart';

class SIconTextButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final colors = sKit.colors;

    TextStyle? tStyle = sTextButtonStyle;
    if (textStyle != null) {
      tStyle = textStyle!;
    }

    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: colors.grey5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ).copyWith(
        overlayColor: MaterialStateProperty.all(colors.grey4),
      ),
      onPressed: onTap,
      child: Row(
        mainAxisSize: mainAxisSize,
        children: [
          if (icon != null) ...[
            icon!,
            const SpaceW8(),
          ],
          Text(
            text,
            style: tStyle,
          ),
          if (rightIcon != null) ...[
            const Spacer(),
            rightIcon!,
          ],
        ],
      ),
    );
  }
}
