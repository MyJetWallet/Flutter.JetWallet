import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

/// This provider must be called after sNavigatorKeyPod 
/// is initialized in MaterialApp
final mediaQueryPod = Provider<MediaQueryData>(
  (ref) {
    final context = ref.read(sNavigatorKeyPod).currentContext!;

    return MediaQuery.of(context);
  },
  name: 'mediaQueryPod',
);
