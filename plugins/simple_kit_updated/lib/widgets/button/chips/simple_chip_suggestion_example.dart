import 'package:flutter/material.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/button/chips/simple_chip_suggestion.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Chip Suggestion',
  type: SChipSuggestion,
)
SChipSuggestion simpleBottomBar1Example(BuildContext context) {
  return SChipSuggestion(
    leftIcon: Assets.svg.other.btc.simpleSvg(),
    subTitle: context.knobs.string(label: 'Subtitle', initialValue: 'Subtitle'),
    title: context.knobs.string(label: 'Title', initialValue: 'Title'),
    rightValue: context.knobs.string(label: 'Right Value', initialValue: '0'),
    callback: () {},
  );
}
