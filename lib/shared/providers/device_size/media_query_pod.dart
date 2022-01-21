import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Will be updated in the AppBuilder
final mediaQueryPod = StateProvider<MediaQueryData?>(
  (ref) => null,
  name: 'mediaQueryPod',
);
