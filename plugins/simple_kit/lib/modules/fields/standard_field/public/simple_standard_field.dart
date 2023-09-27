import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/helpers/validators/validator.dart';
import 'package:simple_kit/utils/enum.dart';

import '../light/simple_light_standard_field.dart';

class SStandardField extends StatelessObserverWidget {
  const SStandardField({
    Key? key,
    this.keyboardType,
    this.textInputAction,
    this.controller,
    this.autofillHints,
    this.focusNode,
    //this.errorNotifier,
    this.onTap,
    this.onErrorIconTap,
    this.suffixIcons,
    this.onErase,
    this.onChanged,
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
    this.hideLabel = false,
    this.grayLabel = false,
    this.validators = const [],
    this.maxLength,
    this.maxLines,
    required this.labelText,
    this.height,
  }) : super(key: key);

  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  //final StandardFieldErrorNotifier? errorNotifier;
  final Function()? onTap;
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
  final bool hideLabel;
  final bool grayLabel;
  final List<Validator> validators;
  final int? maxLength;
  final int? maxLines;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightStandardField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            focusNode: focusNode,
            //errorNotifier: errorNotifier,
            onTap: onTap,
            onErrorIconTap: onErrorIconTap,
            onChanged: onChanged,
            labelText: labelText,
            autofocus: autofocus,
            readOnly: readOnly,
            initialValue: initialValue,
            autofillHints: autofillHints,
            alignLabelWithHint: alignLabelWithHint,
            textCapitalization: textCapitalization,
            onErase: onErase,
            suffixIcons: suffixIcons,
            hideClearButton: hideClearButton,
            hideIconsIfError: hideIconsIfError,
            hideIconsIfNotEmpty: hideIconsIfNotEmpty,
            enabled: enabled,
            hideSpace: hideSpace,
            disableErrorOnChanged: disableErrorOnChanged,
            enableInteractiveSelection: enableInteractiveSelection,
            inputFormatters: inputFormatters,
            isError: isError,
            validators: validators,
            hasManualError: hasManualError,
            hideLabel: hideLabel,
            maxLength: maxLength,
            grayLabel: grayLabel,
            maxLines: maxLines,
            height: height,
          )
        : SimpleLightStandardField(
            controller: controller,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            focusNode: focusNode,
            //errorNotifier: errorNotifier,
            onTap: onTap,
            onErrorIconTap: onErrorIconTap,
            onChanged: onChanged,
            labelText: labelText,
            autofocus: autofocus,
            readOnly: readOnly,
            initialValue: initialValue,
            autofillHints: autofillHints,
            alignLabelWithHint: alignLabelWithHint,
            textCapitalization: textCapitalization,
            onErase: onErase,
            suffixIcons: suffixIcons,
            hideClearButton: hideClearButton,
            hideIconsIfError: hideIconsIfError,
            hideIconsIfNotEmpty: hideIconsIfNotEmpty,
            enabled: enabled,
            hideSpace: hideSpace,
            disableErrorOnChanged: disableErrorOnChanged,
            enableInteractiveSelection: enableInteractiveSelection,
            inputFormatters: inputFormatters,
            isError: isError,
            validators: validators,
            hasManualError: hasManualError,
            hideLabel: hideLabel,
            maxLength: maxLength,
            grayLabel: grayLabel,
            maxLines: maxLines,
            height: height,
          );
  }
}
