import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors_light.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(
  name: 'Colors',
  type: GridView,
)
GridView kitColors(BuildContext context) {
  return GridView.count(
    crossAxisCount: 5,
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
    children: [
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().white,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().black,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().grayAlfa,
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

      // Gray

      Container(
        width: 50,
        height: 50,
        color: Colors.transparent,
      ),

      // Gray

      Container(
        width: 50,
        height: 50,
        color: SColorsLight().gray10,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().gray8,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().gray6,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().gray4,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().gray2,
      ),

      // Blue

      Container(
        width: 50,
        height: 50,
        color: Colors.transparent,
      ),

      // Blue

      Container(
        width: 50,
        height: 50,
        color: SColorsLight().blueDark,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().blue,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().blueLight,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().blueExtralight,
      ),

      // Red

      Container(
        width: 50,
        height: 50,
        color: Colors.transparent,
      ),

      // Red

      Container(
        width: 50,
        height: 50,
        color: SColorsLight().redDark,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().red,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().redLight,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().redExtralight,
      ),

      // Green

      Container(
        width: 50,
        height: 50,
        color: Colors.transparent,
      ),

      // Green

      Container(
        width: 50,
        height: 50,
        color: SColorsLight().greenDark,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().green,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().greenLight,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().greenExtralight,
      ),

      // Yellow

      Container(
        width: 50,
        height: 50,
        color: Colors.transparent,
      ),

      // Yellow

      Container(
        width: 50,
        height: 50,
        color: SColorsLight().yellowDark,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().yellow,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().yellowLight,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().yellowExtralight,
      ),

      // Gradient

      Container(
        width: 50,
        height: 50,
        color: Colors.transparent,
      ),

      // Gradient

      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: SColorsLight().blueGradient,
        ),
      ),
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: SColorsLight().greenGradient,
        ),
      ),
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: SColorsLight().greenLightGradient,
        ),
      ),
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: SColorsLight().purpleGradient,
        ),
      ),
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: SColorsLight().redGradient,
        ),
      ),

      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: SColorsLight().orangeRadialGradient,
        ),
      ),
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: SColorsLight().redRadialGradient,
        ),
      ),
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: SColorsLight().greenRadialGradient,
        ),
      ),
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: SColorsLight().greenLightOneGradient,
        ),
      ),
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: SColorsLight().greenLightTwoGradient,
        ),
      ),
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: SColorsLight().blue1RadialGradient,
        ),
      ),
      Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          gradient: SColorsLight().blue2RadialGradient,
        ),
      ),

      // Extra Lights

      Container(
        width: 50,
        height: 50,
        color: Colors.transparent,
      ),

      // Extra Lights

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
        color: SColorsLight().extraLightsGreenLight,
      ),
      Container(
        width: 50,
        height: 50,
        color: SColorsLight().extraLightsGreenExtraLight,
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
      ),
    ],
  );
}
