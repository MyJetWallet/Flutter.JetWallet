import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'high_yield_disclaimer_notifier.dart';
import 'high_yield_disclaimer_state.dart';

final highYieldDisclaimerNotipod =
    StateNotifierProvider
        .autoDispose<HighYieldDisclaimerNotifier, HighYieldDisclaimerState>(
  (ref) {
    return HighYieldDisclaimerNotifier(
      read: ref.read,
    );
  },
  name: 'highYieldDisclaimerNotipod',
);
