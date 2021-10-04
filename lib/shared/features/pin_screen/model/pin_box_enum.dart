import 'package:flutter/material.dart';

enum PinBoxEnum {
  empty,
  filled,
  correct,
  success,
  error,
}

extension PinBoxEnumExtension on PinBoxEnum {
  Color get color {
    if (this == PinBoxEnum.empty) {
      return Colors.black;
    } else if (this == PinBoxEnum.filled) {
      return Colors.black;
    } else if (this == PinBoxEnum.correct) {
      return Colors.blue;
    } else if (this == PinBoxEnum.success) {
      return Colors.green;
    } else if (this == PinBoxEnum.error) {
      return Colors.red;
    } else {
      return Colors.black;
    }
  }
}
