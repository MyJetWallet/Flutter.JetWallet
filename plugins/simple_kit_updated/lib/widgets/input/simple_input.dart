import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:gap/gap.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SInput extends HookWidget {
  const SInput({
    super.key,
    this.controller,
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
    this.suffixIcon,
    this.onTextFieldTap,
    this.focusNode,
    this.keyboardType = TextInputType.name,
    this.inputFormatters,
    this.textCapitalization,
    this.obscureText = false,
    this.autofocus = false,
    this.withoutVerticalPadding = false,
    this.initialValue,
    this.onChanged,
    this.autofillHints,
    this.maxLength,
    this.textInputAction,
  });

  final VoidCallback? onTextFieldTap;
  final FocusNode? focusNode;
  final bool obscureText;
  final TextInputType keyboardType;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCapitalization;
  final Widget? suffixIcon;
  final bool withoutVerticalPadding;
  final int? maxLength;
  final TextInputAction? textInputAction;

  final String? initialValue;
  final void Function(String)? onChanged;
  final Iterable<String>? autofillHints;

  final String? label;
  final String? hint;
  final double? height;

  final bool isDisabled;

  final bool hasCloseIcon;
  // TODO (Yaroslav): implement lable icon
  final bool hasLabelIcon;
  final bool hasErrorIcon;

  final VoidCallback? onCloseIconTap;
  final VoidCallback? onLabelIconTap;
  final VoidCallback? onErrorIconTap;

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller2 = controller ??
        TextEditingController(
          text: initialValue,
        );

    useListenable(controller2);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(width: 1, color: SColorsLight().gray4)),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: height ?? 80,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    onTap: onTextFieldTap,
                    readOnly: isDisabled,
                    style: STStyles.subtitle1.copyWith(
                      color: isDisabled ? SColorsLight().gray6 : SColorsLight().black,
                    ),
                    controller: controller2,
                    onChanged: onChanged,
                    maxLines: 1,
                    focusNode: focusNode,
                    obscureText: obscureText,
                    keyboardType: keyboardType,
                    autofocus: autofocus,
                    inputFormatters: [
                      ...?inputFormatters,
                      LengthLimitingTextInputFormatter(maxLength),
                    ],
                    textCapitalization: textCapitalization ?? TextCapitalization.none,
                    cursorWidth: 3.0,
                    cursorColor: SColorsLight().blue,
                    cursorRadius: Radius.zero,
                    autofillHints: autofillHints,
                    textInputAction: textInputAction,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: withoutVerticalPadding
                          ? const EdgeInsets.symmetric(vertical: 17)
                          : const EdgeInsets.only(left: 24, top: 17, bottom: 17),
                      border: InputBorder.none,
                      hintText: hint,
                      labelText: label,
                      hintStyle: STStyles.subtitle1.copyWith(
                        color: SColorsLight().gray8,
                      ),
                      labelStyle: STStyles.subtitle1.copyWith(
                        color: SColorsLight().gray8,
                      ),
                      floatingLabelStyle: STStyles.body2Medium.copyWith(
                        color: SColorsLight().gray8,
                      ),
                      suffixIconConstraints: const BoxConstraints(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: withoutVerticalPadding ? 0 : 24),
              child: suffixIcon ??
                  (hasCloseIcon || hasErrorIcon
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Gap(24),
                            if (hasCloseIcon) ...[
                              SafeGesture(
                                highlightColor: Colors.transparent,
                                onTap: () {
                                  onCloseIconTap?.call();
                                  controller2.clear();
                                  onChanged?.call('');
                                },
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
                      : Container()),
            ),
          ],
        ),
      ),
    );
  }
}
