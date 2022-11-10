import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_kit/modules/fields/standard_field/base/simple_base_standart_field.dart';
import 'package:simple_kit/simple_kit.dart';

class SimpleLightStandardField extends StatelessWidget {
  const SimpleLightStandardField({
    Key? key,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.autofillHints,
    this.focusNode,
    this.onErrorIconTap,
    this.onErase,
    this.onChanged,
    this.suffixIcons,
    this.initialValue,
    this.inputFormatters,
    this.textCapitalization,
    this.disableErrorOnChanged = true,
    this.enableInteractiveSelection = true,
    this.hideClearButton = false,
    this.hideIconsIfNotEmpty = true,
    this.hideIconsIfError = true,
    this.autofocus = false,
    this.readOnly = false,
    this.alignLabelWithHint = false,
    this.enabled = true,
    this.hideSpace = false,
    this.isError = false,
    this.hasManualError = false,
    this.validators = const [],
    required this.labelText,
  })  : assert(
          (controller == null && initialValue != null) ||
              (controller != null && initialValue == null) ||
              (controller == null && initialValue == null),
          "Controller and initialValue can't be both provided",
        ),
        super(key: key);

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  final Function()? onErrorIconTap;
  final Function()? onErase;
  final Function(String)? onChanged;
  final List<Widget>? suffixIcons;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization? textCapitalization;
  final bool disableErrorOnChanged;
  final bool enableInteractiveSelection;
  final bool hideClearButton;
  final bool hideIconsIfNotEmpty;
  final bool hideIconsIfError;
  final bool autofocus;
  final bool readOnly;
  final bool alignLabelWithHint;
  final bool enabled;
  final bool hideSpace;
  final String labelText;
  final bool isError;
  final bool hasManualError;
  final List<Validator> validators;

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller2 = controller ??
        TextEditingController(
          text: initialValue,
        );

    return SimpleBaseStandardField(
      labelText: labelText,
      onChanged: onChanged,
      controller: controller2,
      focusNode: focusNode,
      onErrorIconTap: onErrorIconTap,
      keyboardType: keyboardType,
      autofocus: autofocus,
      readOnly: readOnly,
      autofillHints: autofillHints,
      textInputAction: textInputAction,
      textCapitalization: textCapitalization,
      alignLabelWithHint: alignLabelWithHint,
      enabled: enabled,
      disableErrorOnChanged: disableErrorOnChanged,
      enableInteractiveSelection: enableInteractiveSelection,
      inputFormatters: inputFormatters,
      hideSpace: hideSpace,
      hasManualError: hasManualError,
      suffixIcons: [
        if (!hideIconsIfNotEmpty || !controller2.text.isNotEmpty)
          ...?suffixIcons,
      ],
      eraseIcon: [
        if (controller2.text.isNotEmpty && !hideClearButton) ...[
          const SpaceW16(),
          GestureDetector(
            onTap: () {
              controller2.clear();
              onChanged?.call('');
              onErase?.call();
            },
            child: const SEraseIcon(),
          ),
        ],
      ],
      isError: isError,
      validators: validators,
    );
  }
}
