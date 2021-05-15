import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// this key is used for accessing ScaffoldContext of router
// to show snackbars and so on deep in the tree.
final routerKeyPod = Provider<GlobalKey<ScaffoldState>>((ref) {
  return GlobalKey<ScaffoldState>();
});
