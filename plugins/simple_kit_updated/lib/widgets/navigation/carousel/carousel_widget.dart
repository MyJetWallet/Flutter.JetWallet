import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

class CarouselWidget extends HookWidget {
  const CarouselWidget({
    Key? key,
    required this.itemsCount,
    required this.pageIndex,
  }) : super(key: key);

  final int itemsCount;
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        itemsCount,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(right: 2),
          height: 2,
          // width: 16, NEW CAROUSEL WIDTH
          width: 8,
          decoration: BoxDecoration(
            color: index == pageIndex ? SColorsLight().black : SColorsLight().black.withOpacity(.1),
          ),
        ),
      ),
    );
  }
}
