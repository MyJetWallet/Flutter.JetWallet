import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit/core/simple_kit.dart';
import 'package:simple_kit/helpers/validators/validator.dart';
import 'package:simple_kit/utils/enum.dart';
import '../light/simple_light_standard_field_obscure.dart';

class SStandardFieldObscure extends StatelessObserverWidget {
  const SStandardFieldObscure({
    super.key,
    this.autofocus = false,
    this.controller,
    this.focusNode,
    this.autofillHints,
    //this.errorNotifier,
    this.onErrorIconTap,
    this.keyboardType,
    this.inputFormatters,
    this.isError = false,
    this.validators = const [],
    required this.onChanged,
    required this.labelText,
    this.maxLength,
    this.onHideTap,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Iterable<String>? autofillHints;
  //final StandardFieldErrorNotifier? errorNotifier;
  final Function()? onErrorIconTap;
  final Function(String) onChanged;
  final String labelText;
  final bool autofocus;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isError;
  final List<Validator> validators;
  final int? maxLength;
  final Function(bool)? onHideTap;

  @override
  Widget build(BuildContext context) {
    return sKit.currentTheme == STheme.dark
        ? SimpleLightStandardFieldObscure(
            controller: controller,
            focusNode: focusNode,
            //errorNotifier: errorNotifier,
            onErrorIconTap: onErrorIconTap,
            onChanged: onChanged,
            labelText: labelText,
            autofillHints: autofillHints,
            autofocus: autofocus,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            isError: isError,
            validators: validators,
            maxLength: maxLength,
            onHideTap: onHideTap,
          )
        : SimpleLightStandardFieldObscure(
            controller: controller,
            focusNode: focusNode,
            //errorNotifier: errorNotifier,
            onErrorIconTap: onErrorIconTap,
            onChanged: onChanged,
            labelText: labelText,
            autofillHints: autofillHints,
            autofocus: autofocus,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            isError: isError,
            validators: validators,
            maxLength: maxLength,
            onHideTap: onHideTap,
          );
  }
}
