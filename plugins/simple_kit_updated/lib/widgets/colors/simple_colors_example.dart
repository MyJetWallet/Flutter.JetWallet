import 'package:flutter/cupertino.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Colors',
  type: GridView,
)
GridView kitColors(BuildContext context) {
  return GridView.count(
    crossAxisCount: 5,
    children: [
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().black,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().blackAlfa12,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().blackAlfa52,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().blue,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().blueDark,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().blueExtralight,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().blueLight,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().blueLight,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().extraLightsBlue,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().extraLightsGreen,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().extraLightsGreenExtraLight,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().extraLightsGreenLight,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().extraLightsPurple,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().extraLightsRed,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().extraLightsYellow,
      )
    ],
  );
}
