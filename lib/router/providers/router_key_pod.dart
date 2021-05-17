import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// this key is used for accessing ScaffoldKey of router
// to show snackbars somewhere deep in the tree and so on 
final routerKeyPod = Provider<GlobalKey<ScaffoldState>>((ref) {
  return GlobalKey<ScaffoldState>();
});
