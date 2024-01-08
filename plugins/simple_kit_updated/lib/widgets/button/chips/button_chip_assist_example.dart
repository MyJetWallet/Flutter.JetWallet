import 'package:flutter/material.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/widgets/button/chips/button_chip_assist.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Assist',
  type: ByttonChipAssist,
)
ByttonChipAssist simpleBottomBar1Example(BuildContext context) {
  return ByttonChipAssist(
    leftIcon: Assets.svg.small.info,
    rightIcon: Assets.svg.medium.shevronRight,
    text: 'Label',
    rightText: '5',
    callback: () {},
  );
}
