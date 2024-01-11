import 'package:flutter/material.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/widgets/button/chips/button_chip_assist.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Button Chip Assist',
  type: ButtonChipAssist,
)
ButtonChipAssist simpleBottomBar1Example(BuildContext context) {
  return ButtonChipAssist(
    leftIcon: Assets.svg.small.info,
    rightIcon: Assets.svg.medium.shevronRight,
    text: context.knobs.string(label: 'Text', initialValue: 'Label'),
    rightText: context.knobs.string(label: 'Right Text', initialValue: '5'),
    callback: () {},
  );
}
