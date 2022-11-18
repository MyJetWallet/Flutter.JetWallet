import 'package:flutter/material.dart';

extension STimerAnimationCountdown on AnimationController {
  void countdown() {
    reverse(from: value == 0.0 ? 1.0 : value);
  }
}
