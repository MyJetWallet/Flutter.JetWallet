import 'package:hooks_riverpod/hooks_riverpod.dart';

/// If current withdraw session was opened from dynamicLink return true
final withdrawDynamicLinkStpod = StateProvider.autoDispose.family<bool, String>(
  (ref, id) {
    return false;
  },
  name: 'withdrawDynamicLinkStpod',
);
