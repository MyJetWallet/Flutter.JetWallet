import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../shared/features/key_value/notifier/key_value_notipod.dart';
import '../../../shared/providers/cards_pod/cards_pod.dart';
import 'bottom_navigation_notifier.dart';
import 'bottom_navigation_state.dart';

final bottomNavigationNotipod = StateNotifierProvider
    .autoDispose<BottomNavigationNotifier, BottomNavigationState>(
      (ref) {
    final keyValue = ref.watch(keyValueNotipod);
    final cards = ref.watch(cardsPod);

    final cardsIds = keyValue.cards?.value ?? <String>[];

    return BottomNavigationNotifier(
      read: ref.read,
      cardsIds: cardsIds,
      cards: cards,
    );
  },
  name: 'bottomNavigationNotipod',
);
