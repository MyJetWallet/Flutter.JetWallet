import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/widgets/shared/safe_gesture.dart';

class SInput extends HookWidget {
  const SInput({
    Key? key,
    required this.controller,
    this.label,
    this.hint,
    this.height,
    this.isDisabled = false,
    this.hasCloseIcon = false,
    this.hasLabelIcon = false,
    this.hasErrorIcon = false,
    this.onCloseIconTap,
    this.onLabelIconTap,
    this.onErrorIconTap,

    //

    this.onTextFieldTap,
    this.focusNode,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization,
    this.obscureText = false,
    this.autofocus = false,
  }) : super(key: key);

  final VoidCallback? onTextFieldTap;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextInputType? keyboardType;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCapitalization;

  final String? label;
  final String? hint;
  final double? height;

  final bool isDisabled;

  final bool hasCloseIcon;
  final bool hasLabelIcon;
  final bool hasErrorIcon;

  final VoidCallback? onCloseIconTap;
  final VoidCallback? onLabelIconTap;
  final VoidCallback? onErrorIconTap;

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    useListenable(controller);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 1, color: SColorsLight().gray4)),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: height ?? 80,
        ),
        child: Padding(
          padding: label == null
              ? const EdgeInsets.symmetric(horizontal: 24, vertical: 26)
              : const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          child: Center(
            child: TextFormField(
              readOnly: isDisabled,
              style: STStyles.subtitle1,
              controller: controller,
              maxLines: null,
              focusNode: focusNode,
              obscureText: obscureText,
              keyboardType: keyboardType,
              autofocus: autofocus,
              inputFormatters: inputFormatters,
              textCapitalization: textCapitalization ?? TextCapitalization.none,
              cursorWidth: 3.0,
              cursorColor: SColorsLight().blue,
              cursorRadius: Radius.zero,
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
                labelText: label ?? '',
                labelStyle: STStyles.captionMedium.copyWith(
                  color: SColorsLight().gray8,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintText: hint,
                hintStyle: STStyles.subtitle1.copyWith(
                  color: SColorsLight().gray8,
                ),
                suffixIconConstraints: const BoxConstraints(),
                suffixIcon: hasCloseIcon || hasErrorIcon
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Gap(24),
                          if (hasCloseIcon) ...[
                            SafeGesture(
                              highlightColor: Colors.transparent,
                              onTap: onCloseIconTap,
                              child: Assets.svg.medium.closeAlt.simpleSvg(
                                width: 24,
                                height: 24,
                                color: SColorsLight().gray6,
                              ),
                            ),
                          ],
                          if (hasErrorIcon) ...[
                            const Gap(16),
                            SafeGesture(
                              highlightColor: Colors.transparent,
                              onTap: onErrorIconTap,
                              child: Assets.svg.small.warning.simpleSvg(
                                width: 24,
                                height: 24,
                                color: SColorsLight().red,
                              ),
                            ),
                          ],
                        ],
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
