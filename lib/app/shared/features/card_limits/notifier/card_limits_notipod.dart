import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../provider/card_limits_spod.dart';
import 'card_limits_notifier.dart';
import 'card_limits_state.dart';

final cardLimitsNotipod = StateNotifierProvider.autoDispose<
    CardLimitsNotifier, CardLimitsState>(
  (ref) {
    final cardLimits = ref.watch(cardLimitsSpod);

    return CardLimitsNotifier(
      ref.read,
      cardLimits,
    );
  },
);
