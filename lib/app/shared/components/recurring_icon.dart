import 'package:flutter/material.dart';
import 'package:simple_kit/simple_kit.dart';

List<Positioned> recurringIcon(SimpleColors colors) {
  return <Positioned>[
    Positioned(
      right: 0,
      top: 0,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: colors.white,
        ),
      ),
    ),
    Positioned(
      right: 1,
      top: 1,
      child: Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3.0),
          color: colors.blue,
        ),
      ),
    ),
  ];
}
