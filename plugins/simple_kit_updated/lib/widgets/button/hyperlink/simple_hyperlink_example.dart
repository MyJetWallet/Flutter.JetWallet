import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/button/hyperlink/simple_hyperlink.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Hyperlink',
  type: SHyperlink,
)
SHyperlink simpleBottomBar1Example(BuildContext context) {
  return SHyperlink(
    text: context.knobs.string(label: 'Link label', initialValue: 'Link label'),
    isDisabled: context.knobs.boolean(label: 'Is Disabled', initialValue: false),
    onTap: () {},
  );
}
