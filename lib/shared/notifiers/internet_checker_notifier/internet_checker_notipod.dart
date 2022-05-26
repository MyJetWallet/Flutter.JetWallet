import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'internet_checker_notifier.dart';
import 'internet_checker_state.dart';

final internetCheckerNotipod =
    StateNotifierProvider<InternetCheckerNotifier, InternetCheckerState>(
  (ref) {
    return InternetCheckerNotifier(ref.read);
  },
  name: 'userInfoNotipod',
);
