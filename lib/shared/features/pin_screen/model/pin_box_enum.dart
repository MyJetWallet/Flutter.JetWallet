import 'package:flutter/material.dart';

enum PinBoxEnum {
  empty,
  filled,
  correct,
  success,
  error,
}

extension PinBoxEnumExtension on PinBoxEnum {
  Color color(
    Color black,
    Color blue,
    Color green,
    Color red,
  ) {
    if (this == PinBoxEnum.empty) {
      return black;
    } else if (this == PinBoxEnum.filled) {
      return black;
    } else if (this == PinBoxEnum.correct) {
      return blue;
    } else if (this == PinBoxEnum.success) {
      return green;
    } else if (this == PinBoxEnum.error) {
      return red;
    } else {
      return black;
    }
  }
}
