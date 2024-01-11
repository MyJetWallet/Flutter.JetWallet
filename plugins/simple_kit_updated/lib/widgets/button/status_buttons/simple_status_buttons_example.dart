import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/button/status_buttons/simple_status_buttons.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Status button',
  type: SStatusButtons,
)
SStatusButtons simpleStatusButton(BuildContext context) {
  return SStatusButtons(
    type: context.knobs.list(
      label: 'Type',
      options: [
        SStatusButtonsType.blue,
        SStatusButtonsType.green,
        SStatusButtonsType.red,
        SStatusButtonsType.yellow,
      ],
    ),
    label: context.knobs.string(label: 'Text'),
  );
}
