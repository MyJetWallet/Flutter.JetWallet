import 'package:flutter/material.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/widgets/navigation/bottom_bar/models/simple_bottom_item_model.dart';
import 'package:simple_kit_updated/widgets/navigation/bottom_bar/simple_bottom_bar.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Bottom bar 1 item',
  type: SBottomBar,
)
SBottomBar simpleBottomBar1Example(BuildContext context) {
  return SBottomBar(
    selectedIndex: 0,
    onChanged: (p0) {},
    items: [
      SBottomItemModel(
        type: BottomItemType.home,
        icon: Assets.svg.large.card,
        text: 'Section',
      ),
    ],
  );
}

@widgetbook.UseCase(
  name: 'Bottom bar 3 items',
  type: SBottomBar,
)
SBottomBar simpleBottomBar3Example(BuildContext context) {
  return SBottomBar(
    selectedIndex: 1,
    onChanged: (p0) {},
    items: [
      SBottomItemModel(
        type: BottomItemType.home,
        icon: Assets.svg.large.card,
        text: 'Section',
      ),
      SBottomItemModel(
        type: BottomItemType.home,
        icon: Assets.svg.large.card,
        text: 'Section',
      ),
      SBottomItemModel(
        type: BottomItemType.home,
        icon: Assets.svg.large.card,
        text: 'Section',
      ),
    ],
  );
}

@widgetbook.UseCase(
  name: 'Bottom bar 5 items',
  type: SBottomBar,
)
SBottomBar simpleBottomBar5Example(BuildContext context) {
  return SBottomBar(
    selectedIndex: 3,
    onChanged: (p0) {},
    items: [
      SBottomItemModel(
        type: BottomItemType.home,
        icon: Assets.svg.large.card,
        text: 'Section',
      ),
      SBottomItemModel(
        type: BottomItemType.home,
        icon: Assets.svg.large.card,
        text: 'Section',
      ),
      SBottomItemModel(
        type: BottomItemType.home,
        icon: Assets.svg.large.card,
        text: 'Section',
      ),
      SBottomItemModel(
        type: BottomItemType.home,
        icon: Assets.svg.large.card,
        text: 'Section',
      ),
      SBottomItemModel(
        type: BottomItemType.home,
        icon: Assets.svg.large.card,
        text: 'Section',
      ),
    ],
  );
}
