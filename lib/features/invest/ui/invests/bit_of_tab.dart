import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';

class BitOfTap extends StatelessObserverWidget {
  const BitOfTap({
    super.key,
    required this.value,
    required this.onTap,
    required this.isActive,
  });

  final String value;
  final Function() onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colors = SColorsLight();

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      onTap: () {
        onTap();
      },
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: isActive ? colors.white : colors.gray2,
          border: Border.all(
            color: isActive ? colors.blue : colors.gray2,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            value,
            style: STStyles.body2InvestSM.copyWith(
              color: isActive ? colors.blue : colors.black,
              height: 1,
            ),
          ),
        ),
      ),
    );
  }
}
