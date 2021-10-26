import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigatorKeyPod = Provider<GlobalKey<NavigatorState>>(
  (ref) {
    return GlobalKey<NavigatorState>();
  },
  name: 'navigatorKeyPod',
);
