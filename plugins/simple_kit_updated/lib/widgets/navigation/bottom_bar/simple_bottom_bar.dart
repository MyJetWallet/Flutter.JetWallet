import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:simple_kit_updated/widgets/navigation/bottom_bar/models/simple_bottom_item_model.dart';
import 'package:simple_kit_updated/widgets/navigation/bottom_bar/simple_bottom_button.dart';

class SBottomBar extends StatelessWidget {
  const SBottomBar({
    Key? key,
    required this.selectedIndex,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  final int selectedIndex;
  final List<SBottomItemModel> items;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 73,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1, color: SColorsLight().gray4),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      //margin: const EdgeInsets.only(bottom: 34),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: items
            .mapIndexed(
              (index, item) => SBottomButton(
                icon: item.icon,
                text: item.text,
                isActive: selectedIndex == index,
                width: (MediaQuery.of(context).size.width - 48) / items.length,
                notification: item.notification ?? 0,
                onChanged: () {
                  onChanged(index);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
