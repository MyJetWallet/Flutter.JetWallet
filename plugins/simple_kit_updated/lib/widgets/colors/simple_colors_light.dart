import 'package:flutter/material.dart';
import 'package:simple_kit_updated/widgets/colors/simple_colors.dart';

class SColorsLight implements SColors {
  @override
  Color white = Colors.white;
  @override
  Color black = const Color(0xFF000000);
  @override
  Color grayAlfa = const Color(0xFF001C4C).withOpacity(.12);
  @override
  Color blackAlfa12 = const Color(0xFF000000).withOpacity(.12);
  @override
  Color blackAlfa52 = const Color(0xFF000000).withOpacity(.52);

  @override
  Color gray10 = const Color(0xFF777C85);
  @override
  Color gray8 = const Color(0xFFA8B0BA);
  @override
  Color gray6 = const Color(0xFFC0C4C9);
  @override
  Color gray4 = const Color(0xFFE0E4EA);
  @override
  Color gray2 = const Color(0xFFF1F4F8);

  @override
  Color blueDark = const Color(0xFF2238EA);
  @override
  Color blue = const Color(0xFF374DFB);
  @override
  Color blueLight = const Color(0xFFB2BBFF);
  @override
  Color blueExtralight = const Color(0xFFE4E7FF);

  @override
  Color redDark = const Color(0xFFD00832);
  @override
  Color red = const Color(0xFFF50537);
  @override
  Color redLight = const Color(0xFFFB9BAF);
  @override
  Color redExtralight = const Color(0xFFFEE3E9);

  @override
  Color greenDark = const Color(0xFF049813);
  @override
  Color green = const Color(0xFF0BCA1E);
  @override
  Color greenLight = const Color(0xFF9DEAA5);
  @override
  Color greenExtralight = const Color(0xFFE4F9E6);

  @override
  Color yellowDark = const Color(0xFFD1A300);
  @override
  Color yellow = const Color(0xFFF9C321);
  @override
  Color yellowLight = const Color(0xFFF9E29E);
  @override
  Color yellowExtralight = const Color(0xFFFDF5DD);

  @override
  LinearGradient blueGradient = const LinearGradient(
    begin: Alignment(0.89, -0.46),
    end: Alignment(-0.89, 0.46),
    colors: [Color(0xFF79EECC), Color(0xFF30CACE)],
  );
  @override
  LinearGradient greenGradient = const LinearGradient(
    begin: Alignment(0.90, -0.44),
    end: Alignment(-0.9, 0.44),
    colors: [Color(0xFF8BEBB1), Color(0xFF1ECB82)],
  );
  @override
  LinearGradient greenLightGradient = const LinearGradient(
    begin: Alignment(-0.90, 0.44),
    end: Alignment(0.9, -0.44),
    colors: [Color(0xFF8ADE39), Color(0xFFBEF275)],
  );
  @override
  LinearGradient purpleGradient = const LinearGradient(
    begin: Alignment(0.90, -0.44),
    end: Alignment(-0.9, 0.44),
    colors: [Color(0xFFCBB9FF), Color(0xFF9575F3)],
  );
  @override
  LinearGradient redGradient = const LinearGradient(
    begin: Alignment(0.90, -0.44),
    end: Alignment(-0.9, 0.44),
    colors: [Color(0xFFF6825E), Color(0xFFF75F47)],
  );

  @override
  RadialGradient orangeRadialGradient = const RadialGradient(
    center: Alignment(0.75, 0.17),
    radius: 0.42,
    colors: [Color(0xFFF5A79C), Color(0xFFFFC3A2), Color(0xFFFFDAA2), Color(0xFFF8FFAF)],
  );
  @override
  RadialGradient redRadialGradient = const RadialGradient(
    center: Alignment(0.75, 0.17),
    radius: 0.42,
    colors: [Color(0xFFD88FB4), Color(0xFFF7B8B8), Color(0xFFFFC9BE), Color(0xFFFDFFEA)],
  );
  @override
  RadialGradient greenRadialGradient = const RadialGradient(
    center: Alignment(0.75, 0.17),
    radius: 0.42,
    colors: [Color(0xFF98D569), Color(0xFF8EE89C), Color(0xFFA2EBDE), Color(0xFFEAFFFD)],
  );
  @override
  RadialGradient greenLightOneGradient = const RadialGradient(
    center: Alignment(0.75, 0.17),
    radius: 0.42,
    colors: [Color(0xFF9AF5B3), Color(0xFFC3D9CA), Color(0xFFD7FB8A), Color(0xFFFFEAFA)],
  );
  @override
  RadialGradient greenLightTwoGradient = const RadialGradient(
    center: Alignment(0.75, 0.17),
    radius: 0.42,
    colors: [Color(0xFF9AF5B3), Color(0xFFC3D9CA), Color(0xFFD7FB8A), Color(0xFFFFEAFA)],
  );
  @override
  RadialGradient purpleRadialGradient = const RadialGradient(
    center: Alignment(0.75, 0.17),
    radius: 0.42,
    colors: [Color(0xFFC8B7F9), Color(0xFFD4C0FF), Color(0xFFBBBAF8), Color(0xFFD9DCFA)],
  );
  @override
  RadialGradient blue1RadialGradient = const RadialGradient(
    center: Alignment(0.75, 0.17),
    radius: 0.42,
    colors: [Color(0xFF9AA2E9), Color(0xFFA0C0F0), Color(0xFFBAD4F8), Color(0xFFFFEAFA)],
  );
  @override
  RadialGradient blue2RadialGradient = const RadialGradient(
    center: Alignment(0.75, 0.17),
    radius: 0.42,
    colors: [Color(0xFFD88FB4), Color(0xFFD5C3D9), Color(0xFFBAD4F8), Color(0xFFFFEAFA)],
  );

  @override
  Color extraLightsBlue = const Color(0xFFE0EBFA);
  @override
  Color extraLightsGreen = const Color(0xFFEDFAF6);
  @override
  Color extraLightsGreenLight = const Color(0xFFEDFAF2);
  @override
  Color extraLightsGreenExtraLight = const Color(0xFFF5FAEE);
  @override
  Color extraLightsPurple = const Color(0xFFF6F2FF);
  @override
  Color extraLightsRed = const Color(0xFFFFF5F2);
  @override
  Color extraLightsYellow = const Color(0xFFFEF9EC);

  @override
  LinearGradient mainScreenGradient = const LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [
      Color(0xFF9575F3),
      Color(0xFF9E81F4),
      Color(0xFFA58AF4),
      Color(0xFFAB91F5),
      Color(0xFFAF97F5),
      Color(0xFFB29BF6),
      Color(0xFFB59FF6),
      Color(0xFFB8A3F7),
      Color(0xFFBCA8F7),
      Color(0xFFC0ADF7),
      Color(0xFFC5B4F8),
      Color(0xFFCCBCF9),
      Color(0xFFD5C8FA),
      Color(0xFFE0D6FB),
      Color(0xFFEDE8FD),
      Colors.white
    ],
  );
  @override
  LinearGradient walletGradient = const LinearGradient(
    begin: Alignment(0.02, 1.00),
    end: Alignment(-0.02, -1),
    colors: [
      Colors.white,
      Color(0xFFF6FCFD),
      Color(0xFFEEFAFB),
      Color(0xFFE5F8F8),
      Color(0xFFDCF6F6),
      Color(0xFFD2F3F4),
      Color(0xFFC8F1F2),
      Color(0xFFBCEEEF),
      Color(0xFFB0EBEC),
      Color(0xFFA2E7E9),
      Color(0xFF93E3E5),
      Color(0xFF83DFE1),
      Color(0xFF71DBDD),
      Color(0xFF5DD6D8),
      Color(0xFF47D0D3),
      Color(0xFF30CACE)
    ],
  );
  @override
  LinearGradient accountGradient = const LinearGradient(
    begin: Alignment(0.00, -1.00),
    end: Alignment(0, 1),
    colors: [
      Color(0xFF55D689),
      Color(0xFF5BD78D),
      Color(0xFF62D992),
      Color(0xFF69DB97),
      Color(0xFF71DC9C),
      Color(0xFF79DEA2),
      Color(0xFF82E0A8),
      Color(0xFF8BE3AE),
      Color(0xFF95E5B5),
      Color(0xFFA0E8BD),
      Color(0xFFADEBC6),
      Color(0xFFBAEECF),
      Color(0xFFC9F2D9),
      Color(0xFFD9F5E5),
      Color(0xFFEBFAF1),
      Colors.white
    ],
  );
}
