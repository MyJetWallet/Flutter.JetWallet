import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'startup_notifier.dart';
import 'startup_state.dart';

final startupNotipod = StateNotifierProvider<StartupNotifier, StartupState>(
  (ref) {
    return StartupNotifier(ref.read);
  },
  name: 'startupNotipod',
);
