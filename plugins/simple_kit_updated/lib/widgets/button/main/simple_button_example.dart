import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/button/main/simple_button.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Simple button - Blue',
  type: SButton,
)
SButton simpleStatusBlueButton(BuildContext context) {
  return SButton.blue(
    text: context.knobs.string(label: 'Text', initialValue: 'Text'),
    isLoading: context.knobs.boolean(label: 'Is Loading', initialValue: false),
    callback: context.knobs.boolean(label: 'Is Disable', initialValue: false) ? null : () {},
  );
}

@widgetbook.UseCase(
  name: 'Simple button - Black',
  type: SButton,
)
SButton simpleStatusBlackButton(BuildContext context) {
  return SButton.black(
    text: context.knobs.string(label: 'Text', initialValue: 'Text'),
    isLoading: context.knobs.boolean(label: 'Is Loading', initialValue: false),
    callback: context.knobs.boolean(label: 'Is Disable', initialValue: false) ? null : () {},
  );
}

@widgetbook.UseCase(
  name: 'Simple button - Red',
  type: SButton,
)
SButton simpleStatusRedButton(BuildContext context) {
  return SButton.red(
    text: context.knobs.string(label: 'Text', initialValue: 'Text'),
    isLoading: context.knobs.boolean(label: 'Is Loading', initialValue: false),
    callback: context.knobs.boolean(label: 'Is Disable', initialValue: false) ? null : () {},
  );
}

@widgetbook.UseCase(
  name: 'Simple button - Outlined',
  type: SButton,
)
SButton simpleStatusOutlinedButton(BuildContext context) {
  return SButton.outlined(
    text: context.knobs.string(label: 'Text', initialValue: 'Text'),
    isLoading: context.knobs.boolean(label: 'Is Loading', initialValue: false),
    callback: context.knobs.boolean(label: 'Is Disable', initialValue: false) ? null : () {},
  );
}

@widgetbook.UseCase(
  name: 'Simple button - Text',
  type: SButton,
)
SButton simpleStatusTextButton(BuildContext context) {
  return SButton.text(
    text: context.knobs.string(label: 'Text', initialValue: 'Text'),
    isLoading: context.knobs.boolean(label: 'Is Loading', initialValue: false),
    callback: context.knobs.boolean(label: 'Is Disable', initialValue: false) ? null : () {},
  );
}
