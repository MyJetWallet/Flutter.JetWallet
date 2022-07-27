import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/cards_model.dart';

import '../signal_r/cards_spod.dart';

final cardsPod = Provider.autoDispose<CardsModel>((ref) {
  final info = ref.watch(cardsSpod);
  var cards = const CardsModel(now: 0, cardInfos: []);

  info.whenData((value) {
    cards = value;
  });

  return cards;
});
