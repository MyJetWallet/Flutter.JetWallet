import 'package:flutter/material.dart';

class SNotification {
  const SNotification({
    required this.duration,
    required this.function,
  });

  final int duration;
  final Function(BuildContext) function;
}
