import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:simple_kit_updated/gen/assets.gen.dart';
import 'package:simple_kit_updated/helpers/icons_extension.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';

enum SPlaceholderSize {
  l,
  xl,
}

enum SPlaceholderMood {
  happy,
  sad,
}

class SPlaceholder extends StatelessWidget {
  const SPlaceholder({
    Key? key,
    required this.size,
    required this.text,
    this.mood = SPlaceholderMood.happy,
  }) : super(key: key);

  final SPlaceholderSize size;
  final String text;
  final SPlaceholderMood mood;

  @override
  Widget build(BuildContext context) {
    double getHeightBaseOnSize() {
      switch (size) {
        case SPlaceholderSize.l:
          return 152;
        case SPlaceholderSize.xl:
          return 288;
        default:
          return 152;
      }
    }

    EdgeInsetsGeometry getPaddingBaseOnSize() {
      switch (size) {
        case SPlaceholderSize.l:
          return const EdgeInsets.symmetric(
            horizontal: 80,
            vertical: 40,
          );
        case SPlaceholderSize.xl:
          return const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 80,
          );
        default:
          return const EdgeInsets.symmetric(
            horizontal: 80,
            vertical: 40,
          );
      }
    }

    Widget getImageBaseOnSizeAndMood() {
      switch (size) {
        case SPlaceholderSize.l:
          return SizedBox(
            width: 48,
            height: 48,
            child: mood == SPlaceholderMood.happy
                ? Assets.svg.other.happySimpleSmall.simpleSvg()
                : Assets.svg.other.sadSimpleSmall.simpleSvg(),
          );
        case SPlaceholderSize.xl:
          return SizedBox(
            width: 96,
            height: 96,
            child: mood == SPlaceholderMood.happy
                ? Assets.svg.other.happySimpleLarge.simpleSvg()
                : Assets.svg.other.sadSimpleLarge.simpleSvg(),
          );
        default:
          return SizedBox(
            width: 48,
            height: 48,
            child: mood == SPlaceholderMood.happy
                ? Assets.svg.other.happySimpleSmall.simpleSvg()
                : Assets.svg.other.sadSimpleSmall.simpleSvg(),
          );
      }
    }

    TextStyle getTextStyletBaseOnSize() {
      switch (size) {
        case SPlaceholderSize.l:
          return STStyles.subtitle2;
        case SPlaceholderSize.xl:
          return STStyles.header5;
        default:
          return STStyles.subtitle2;
      }
    }

    return SizedBox(
      //height: getHeightBaseOnSize(),
      child: Padding(
        padding: getPaddingBaseOnSize(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            getImageBaseOnSizeAndMood(),
            Text(
              text,
              maxLines: 6,
              textAlign: TextAlign.center,
              style: getTextStyletBaseOnSize().copyWith(
                color: SColorsLight().gray8,
              ),
            )
          ],
        ),
      ),
    );
  }
}
