import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/earn_profile_spod.dart';
import 'earn_profile_notifier.dart';
import 'earn_profile_state.dart';

final earnProfileNotipod = StateNotifierProvider.autoDispose<
    EarnProfileNotifier, EarnProfileState>(
  (ref) {
    final earnProfile = ref.watch(earnProfileSpod);

    return EarnProfileNotifier(
      ref.read,
      earnProfile,
    );
  },
);
