import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sNavigatorKeyPod = Provider<GlobalKey<NavigatorState>>(
  (ref) {
    return GlobalKey<NavigatorState>();
  },
  name: 'sNavigatorKeyPod',
);
