import 'package:flutter/cupertino.dart';
import 'package:simple_kit/modules/colors/simple_colors_light.dart';
import 'package:simple_kit/modules/icons/24x24/public/bank_medium/bank_medium_icon.dart';
import 'package:simple_kit/simple_kit.dart';

class BlueBankIcon extends StatelessWidget {
  const BlueBankIcon({
    super.key,
    this.size = 40.0,
  });

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.only(top: 3),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: SColorsLight().blue,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: 16,
        height: 16,
        child: SBankMediumIcon(
          color: SColorsLight().white,
        ),
      ),
    );
  }
}

class BlueBankUnlimitIcon extends StatelessWidget {
  const BlueBankUnlimitIcon({
    super.key,
    this.size = 40.0,
  });

  final double? size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.only(top: 3),
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: SColorsLight().blue,
        shape: BoxShape.circle,
      ),
      child: SizedBox(
        width: 16,
        height: 16,
        child: SAccountIcon(
          color: SColorsLight().white,
        ),
      ),
    );
  }
}
