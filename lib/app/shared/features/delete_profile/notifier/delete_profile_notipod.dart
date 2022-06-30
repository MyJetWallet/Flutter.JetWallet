import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'delete_profile_notifier.dart';
import 'delete_profile_state.dart';

final deleteProfileNotipod =
    StateNotifierProvider.autoDispose<DPNotifier, DPState>(
  (ref) {
    return DPNotifier(
      read: ref.read,
    );
  },
);
