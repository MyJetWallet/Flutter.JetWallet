import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/button/main/base_button.dart';

class SButton extends HookWidget {
  const SButton.blue({
    this.icon,
    required this.text,
    this.callback,
    this.isLoading = false,
    super.key,
    this.borderRadius,
  }) : type = ButtonType.blue;

  const SButton.black({
    this.icon,
    required this.text,
    this.callback,
    this.isLoading = false,
    this.borderRadius,
    super.key,
  }) : type = ButtonType.black;

  const SButton.red({
    this.icon,
    required this.text,
    this.callback,
    this.isLoading = false,
    this.borderRadius,
    super.key,
  }) : type = ButtonType.red;

  const SButton.text({
    this.icon,
    required this.text,
    this.callback,
    this.isLoading = false,
    this.borderRadius,
    super.key,
  }) : type = ButtonType.text;

  const SButton.outlined({
    this.icon,
    required this.text,
    this.callback,
    this.isLoading = false,
    this.borderRadius,
    super.key,
  }) : type = ButtonType.outlined;

  final String text;
  final VoidCallback? callback;
  final bool isLoading;
  final Widget? icon;

  final BorderRadiusGeometry? borderRadius;

  final ButtonType type;

  bool get isDisable => isLoading || callback == null;

  Color backgroundColor() {
    switch (type) {
      case ButtonType.blue:
        return callback != null
            ? isLoading
                ? SColorsLight().blueDark
                : SColorsLight().blue
            : SColorsLight().blueLight;
      case ButtonType.black:
        return callback != null
            ? isLoading
                ? SColorsLight().gray10
                : SColorsLight().black
            : SColorsLight().gray4;
      case ButtonType.red:
        return callback != null
            ? isLoading
                ? SColorsLight().redDark
                : SColorsLight().red
            : SColorsLight().redExtralight;
      case ButtonType.text:
        return isLoading ? SColorsLight().gray2 : Colors.transparent;
      case ButtonType.outlined:
        return isLoading ? SColorsLight().gray2 : SColorsLight().white;
    }
  }

  Color backgroundHighlightedColor() {
    switch (type) {
      case ButtonType.blue:
        return SColorsLight().blueDark;
      case ButtonType.black:
        return SColorsLight().gray10;
      case ButtonType.red:
        return SColorsLight().redDark;
      case ButtonType.text:
        return SColorsLight().gray2;
      case ButtonType.outlined:
        return SColorsLight().gray2;
    }
  }

  Color textColor() {
    switch (type) {
      case ButtonType.blue:
        return SColorsLight().white;
      case ButtonType.black:
        return SColorsLight().white;
      case ButtonType.red:
        return SColorsLight().white;
      case ButtonType.text:
        return callback != null ? SColorsLight().black : SColorsLight().gray4;
      case ButtonType.outlined:
        return callback != null ? SColorsLight().black : SColorsLight().gray4;
    }
  }

  Border? getBorder() {
    switch (type) {
      case ButtonType.outlined:
        return Border.all(
          color: callback != null ? SColorsLight().black : SColorsLight().gray4,
          width: 2,
        );
      default:
        return null;
    }
  }

  EdgeInsets? getPadding() {
    switch (type) {
      case ButtonType.outlined:
        return const EdgeInsets.symmetric(vertical: 14, horizontal: 48);
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isHighlighted = useState(false);

    return BaseButton(
      borderRadius: borderRadius,
      callback: isLoading ? null : callback,
      backgroundColor: isHighlighted.value ? backgroundHighlightedColor() : backgroundColor(),
      border: getBorder(),
      padding: getPadding(),
      onHighlightChanged: (p0) {
        isHighlighted.value = p0;
      },
      child: isLoading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: textColor(),
                  ),
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      text,
                      style: STStyles.button.copyWith(
                        color: textColor(),
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
