import 'package:flutter/material.dart';

import '../../../../../colors/view/simple_colors_light.dart';

class LoaderBackground extends StatelessWidget {
  const LoaderBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: SColorsLight().black.withOpacity(0.5),
    );
  }
}
