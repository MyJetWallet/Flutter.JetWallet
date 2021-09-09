import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final navigatorKeyPod = Provider<GlobalKey<NavigatorState>>(
  (ref) {
    return GlobalKey<NavigatorState>();
  },
  name: 'navigatorKeyPod',
);
