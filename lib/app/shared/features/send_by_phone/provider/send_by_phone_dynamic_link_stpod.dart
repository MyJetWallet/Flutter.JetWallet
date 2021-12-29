import 'package:hooks_riverpod/hooks_riverpod.dart';

/// If current send by phone session was opened from dynamicLink return true
final sendByPhoneDynamicLinkStpod =
    StateProvider.autoDispose.family<bool, String>(
  (ref, id) {
    return false;
  },
  name: 'sendByPhoneDynamicLinkStpod',
);
