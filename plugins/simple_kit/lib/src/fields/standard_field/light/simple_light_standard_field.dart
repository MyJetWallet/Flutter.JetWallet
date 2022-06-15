import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../simple_kit.dart';
import '../base/simple_base_standard_field.dart';

class SimpleLightStandardField extends HookWidget {
  const SimpleLightStandardField({
    Key? key,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.autofillHints,
    this.focusNode,
    this.errorNotifier,
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
  final StandardFieldErrorNotifier? errorNotifier;
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

  @override
  Widget build(BuildContext context) {
    final controller2 = controller ??
        useTextEditingController(
          text: initialValue,
        );
    useListenable(controller2);

    return SimpleBaseStandardField(
      labelText: labelText,
      onChanged: onChanged,
      controller: controller2,
      focusNode: focusNode,
      errorNotifier: errorNotifier,
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
      suffixIcons: [
        if (!hideIconsIfNotEmpty || !controller2.text.isNotEmpty)
          ...?suffixIcons,
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
    );
  }
}
