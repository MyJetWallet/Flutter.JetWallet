import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../providers/cards_pod/cards_pod.dart';
import '../../key_value/notifier/key_value_notipod.dart';
import 'payment_methods_notifier.dart';
import 'payment_methods_state.dart';

final paymentMethodsNotipod = StateNotifierProvider.autoDispose<
    PaymentMethodsNotifier, PaymentMethodsState>(
  (ref) {
    final keyValue = ref.watch(keyValueNotipod);
    final cards = ref.watch(cardsPod);
    final cardsIds = keyValue.cards?.value ?? <String>[];

    return PaymentMethodsNotifier(ref.read, cardsIds, cards);
  },
  name: 'paymentMethodsNotipod',
);
