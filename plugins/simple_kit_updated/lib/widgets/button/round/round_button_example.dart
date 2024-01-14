import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/button/round/round_button.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Round Button',
  type: RoundButton,
)
RoundButton simpleStatusBlueButton(BuildContext context) {
  return RoundButton(
    value: context.knobs.string(label: 'Text', initialValue: '0.00 EUR'),
    isDisabled: context.knobs.boolean(label: 'Is Disabled', initialValue: false),
    onTap: () {},
  );
}
