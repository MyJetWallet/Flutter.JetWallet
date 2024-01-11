import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/button/chips/simple_command_bar.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Command bar',
  type: SCommandBar,
)
SCommandBar simpleBottomBar1Example(BuildContext context) {
  return SCommandBar(
    title: context.knobs.string(label: 'Title', initialValue: 'Title'),
    description: context.knobs.string(label: 'Description', initialValue: 'Description'),
    buttonText: context.knobs.string(label: 'Button Text', initialValue: 'Done'),
    onTap: () {},
  );
}
