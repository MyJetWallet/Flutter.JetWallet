import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final searchStpod = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});