import 'package:flutter/material.dart';

import '../../colors/view/simple_colors_light.dart';


class SStepIndicator extends StatelessWidget {
  const SStepIndicator({
    Key? key,
    required this.loadedPercent,
  }) : super(key: key);

   final  int loadedPercent;

  @override
  Widget build(BuildContext context) {
    var _flex = loadedPercent;
    if(loadedPercent < 0){
      _flex = 0;
    } else if (loadedPercent > 100){
      _flex = 100;
    }
    return Row(
      children: [
        Expanded(
          flex: _flex,
          child: Container(
            color: SColorsLight().blue,
            height: 4,
          ),
        ),
        Expanded(
          flex: 100 - _flex,
          child: Container(
            color: SColorsLight().white,
            height: 4,
          ),
        ),
      ],
    );
  }
}
