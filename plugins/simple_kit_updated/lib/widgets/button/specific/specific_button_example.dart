import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/button/specific/specific_button.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Specific Button',
  type: SpecificButton,
)
SpecificButton simpleStatusBlueButton(BuildContext context) {
  return SpecificButton(
    label: context.knobs.string(label: 'Text', initialValue: 'Label'),
    hasCardIcon: context.knobs.boolean(label: 'Has Card Icon ', initialValue: false),
    hasRightArrow: context.knobs.boolean(label: 'Has Right Arrow ', initialValue: false),
    isLoading: context.knobs.boolean(label: 'Is Loading', initialValue: false),
    isButtonSmall: context.knobs.boolean(label: 'Is Button Small', initialValue: false),
    isLabelBold: context.knobs.boolean(label: 'Is Label Bold', initialValue: false),
    onTap: () {},
  );
}
