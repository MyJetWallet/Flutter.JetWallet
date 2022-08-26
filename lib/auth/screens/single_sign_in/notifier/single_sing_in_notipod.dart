import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'single_sing_in_notifier.dart';

import 'single_sing_in_state.dart';

final singleSingInNotipod = StateNotifierProvider.autoDispose
    <SingleSingInNotifier, SingleSingInState>(
  (ref) {
    return SingleSingInNotifier(ref.read);
  },
);
