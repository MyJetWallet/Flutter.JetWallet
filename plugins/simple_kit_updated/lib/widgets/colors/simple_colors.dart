import 'dart:ui';

import 'package:flutter/material.dart';

abstract class SColors {
  // Basic
  abstract Color black;
  abstract Color blackAlfa52;
  abstract Color blackAlfa12;
  abstract Color grayAlfa;
  abstract Color white;

  // Grayscale
  abstract Color gray10;
  abstract Color gray8;
  abstract Color gray6;
  abstract Color gray4;
  abstract Color gray2;

  // Blue
  abstract Color blueDark;
  abstract Color blue;
  abstract Color blueLight;
  abstract Color blueExtralight;

  // Red
  abstract Color redDark;
  abstract Color red;
  abstract Color redLight;
  abstract Color redExtralight;

  // Green
  abstract Color greenDark;
  abstract Color green;
  abstract Color greenLight;
  abstract Color greenExtralight;

  // Yellow
  abstract Color yellowDark;
  abstract Color yellow;
  abstract Color yellowLight;
  abstract Color yellowExtralight;

  // Linear gradient
  abstract LinearGradient blueGradient;
  abstract LinearGradient greenGradient;
  abstract LinearGradient greenLightGradient;
  abstract LinearGradient purpleGradient;
  abstract LinearGradient redGradient;

  // Radial gradient
  abstract RadialGradient orangeRadialGradient;
  abstract RadialGradient redRadialGradient;
  abstract RadialGradient greenRadialGradient;
  abstract RadialGradient greenLightOneGradient;
  abstract RadialGradient greenLightTwoGradient;
  abstract RadialGradient purpleRadialGradient;
  abstract RadialGradient blue1RadialGradient;
  abstract RadialGradient blue2RadialGradient;

  // Extralight
  abstract Color extraLightsBlue;
  abstract Color extraLightsGreen;
  abstract Color extraLightsGreenLight;
  abstract Color extraLightsGreenExtraLight;
  abstract Color extraLightsPurple;
  abstract Color extraLightsRed;
  abstract Color extraLightsYellow;

  abstract LinearGradient mainScreenGradient;
  abstract LinearGradient walletGradient;
  abstract LinearGradient accountGradient;
}
