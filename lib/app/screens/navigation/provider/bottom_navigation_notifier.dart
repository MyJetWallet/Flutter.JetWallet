import 'dart:convert';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_networking/services/circle/model/circle_card.dart';
import 'package:simple_networking/services/key_value/model/key_value_request_model.dart';
import 'package:simple_networking/services/key_value/model/key_value_response_model.dart';
import 'package:simple_networking/services/signal_r/model/cards_model.dart';

import '../../../../../shared/constants.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../shared/providers/service_providers.dart';
import '../../../shared/features/key_value/notifier/key_value_notipod.dart';
import 'bottom_navigation_state.dart';

class BottomNavigationNotifier extends StateNotifier<BottomNavigationState> {
  BottomNavigationNotifier({
    required this.read,
    required this.cardsIds,
    required this.cards,
  }) : super(
    BottomNavigationState(
      cardsIds: cardsIds,
      cards: cards,
    ),
  ) {
    _init();
  }

  final Reader read;
  final List<String> cardsIds;
  final CardsModel cards;

  static final _logger = Logger('WatchlistNotifier');

  Future<void> _init() async {
    try {
      final response = await read(circleServicePod).allCards();

      final cardsFailing = response.cards.where(
        (element) => element.status == CircleCardStatus.failed,
      ).toList();

      if (cardsFailing.isNotEmpty &&
          cardsFailing.any((element) => !state.cardsIds.contains(element.id))) {
        state = state.copyWith(
          cardNotification: true,
        );
      } else {
        state = state.copyWith(
          cardNotification: false,
        );
      }
    } catch (e) {
      _logger.log(stateFlow, 'initBottomNavigation', e);
    }
  }

  Future<void> addCardToKeyValue(String cardId) async {
    _logger.log(notifier, 'addCard');

    try {
      final set = Set.of(state.cardsIds);
      set.add(cardId);
      state = state.copyWith(
        cardsIds: set.toList(),
      );

      await read(keyValueNotipod.notifier).addToKeyValue(
        KeyValueRequestModel(
          keys: [
            KeyValueResponseModel(
              key: cardsKey,
              value: jsonEncode(state.cardsIds),
            )
          ],
        ),
      );
    } catch (e) {
      _logger.log(stateFlow, 'addCardToKeyValue', e);
    }
  }
}
