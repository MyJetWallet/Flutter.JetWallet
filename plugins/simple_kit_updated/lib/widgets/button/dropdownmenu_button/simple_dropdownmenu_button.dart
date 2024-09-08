import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class SDropdownmenuButton<T> extends StatefulWidget {
  const SDropdownmenuButton({super.key, required this.value, required this.itmes, this.onChanged});

  final T value;
  final List<T> itmes;
  final void Function(T?)? onChanged;

  @override
  State<SDropdownmenuButton<T>> createState() => _SDropdownmenuButtonState<T>();
}

class _SDropdownmenuButtonState<T> extends State<SDropdownmenuButton<T>> {
  bool isDropDownOpened = false;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return DropdownButtonHideUnderline(
      child: DropdownButton2<T>(
        value: widget.value,
        onMenuStateChange: (isOpen) {
          setState(() {
            isDropDownOpened = isOpen;
          });
        },
        onChanged: widget.onChanged,
        items: widget.itmes.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value.toString(),
                  style: STStyles.body2Semibold,
                ),
                if (value == widget.value) Assets.svg.small.check.simpleSvg(width: 16, height: 16)
              ],
            ),
          );
        }).toList(),
        selectedItemBuilder: (context) {
          return widget.itmes.map((item) {
            return Row(
              children: [
                Text(
                  item.toString(),
                  style: STStyles.body2Semibold.copyWith(color: isDropDownOpened ? colors.white : colors.black),
                ),
              ],
            );
          }).toList();
        },
        iconStyleData: IconStyleData(
          icon: isDropDownOpened
              ? Assets.svg.small.arrowUp.simpleSvg(color: colors.white, width: 16, height: 16)
              : Assets.svg.small.arrowDown.simpleSvg(color: colors.black, width: 16, height: 16),
          iconSize: 16,
        ),
        buttonStyleData: ButtonStyleData(
          width: 112,
          height: 28,
          padding: const EdgeInsets.only(top: 5, left: 12, right: 8, bottom: 5),
          decoration: BoxDecoration(
            color: isDropDownOpened ? colors.black : colors.gray2,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        dropdownStyleData: DropdownStyleData(
          width: 134,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colors.white,
            boxShadow: const [
              BoxShadow(
                color: Color(0x51777C85),
                blurRadius: 20,
                offset: Offset(0, 0),
                spreadRadius: 0,
              )
            ],
          ),
          elevation: 0,
          offset: const Offset(0, -8),
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 40,
          padding: EdgeInsets.only(left: 16, right: 12, top: 11, bottom: 11),
        ),
      ),
    );
  }
}
