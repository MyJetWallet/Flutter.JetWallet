import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/circle/model/circle_card.dart';

import '../../../../models/currency_model.dart';
import '../../../../providers/cards_pod/cards_pod.dart';
import '../../../key_value/notifier/key_value_notipod.dart';
import 'currency_buy_notifier.dart';
import 'currency_buy_state.dart';

final currencyBuyNotipod = StateNotifierProvider.autoDispose
    .family<CurrencyBuyNotifier, CurrencyBuyState, CurrencyModel>(
  (ref, currency) {
    final keyValue = ref.watch(keyValueNotipod);
    final cards = ref.watch(cardsPod);
    final unlimintCards = cards.cardInfos.where(
      (element) => element.integration == IntegrationType.unlimint,
    ).toList();
    final bankCards = cards.cardInfos.where(
      (element) => element.integration == IntegrationType.unlimintAlt,
    ).toList();

    return CurrencyBuyNotifier(
      ref.read,
      currency,
      keyValue.lastUsedPaymentMethod,
      unlimintCards,
      bankCards,
    );
  },
);
