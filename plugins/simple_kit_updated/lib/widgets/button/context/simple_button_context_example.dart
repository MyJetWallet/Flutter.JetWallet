import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/button/context/simple_button_context.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Simple button context',
  type: SButtonContext,
)
SButtonContext simpleStatusBlueButton(BuildContext context) {
  return SButtonContext(
    type: context.knobs.list(
      label: 'Type',
      options: [
        SButtonContextType.basic,
        SButtonContextType.basicInverted,
        SButtonContextType.iconedLarge,
        SButtonContextType.iconedLargeInverted,
        SButtonContextType.iconedMedium,
        SButtonContextType.iconedMediumInverted,
        SButtonContextType.iconedSmall,
        SButtonContextType.iconedSmallInverted,
      ],
    ),
    text: context.knobs.string(label: 'Text', initialValue: 'Text'),
    onTap: () {},
    isDisabled: context.knobs.boolean(label: 'Is Disabled', initialValue: false),
  );
}
