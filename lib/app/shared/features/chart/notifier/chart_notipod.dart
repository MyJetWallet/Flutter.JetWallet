import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'chart_notifier.dart';
import 'chart_state.dart';

final chartNotipod = StateNotifierProvider.family<ChartNotifier, ChartState,
    AnimationController?>(
  (ref, controller) {
    return ChartNotifier(
      read: ref.read,
      animationController: controller,
    );
  },
);
