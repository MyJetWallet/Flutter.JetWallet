import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

/// Will be updated in the AppBuilder
final mediaQueryStpod = StateProvider<MediaQueryData?>(
  (ref) => null,
  name: 'mediaQueryStpod',
);
