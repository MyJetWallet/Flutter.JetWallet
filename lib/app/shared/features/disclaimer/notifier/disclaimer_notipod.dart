import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'disclaimer_notifier.dart';
import 'disclaimer_state.dart';

final disclaimerNotipod =
    StateNotifierProvider.autoDispose<DisclaimerNotifier, DisclaimerState>(
  (ref) {
    return DisclaimerNotifier(
      read: ref.read,
    );
  },
);
