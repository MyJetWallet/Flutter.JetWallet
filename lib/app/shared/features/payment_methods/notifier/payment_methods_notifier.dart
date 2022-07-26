import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/circle/model/circle_card.dart';
import 'package:simple_networking/services/circle/model/delete_card/delete_card_request_model.dart';
import 'package:simple_networking/services/key_value/model/key_value_request_model.dart';
import 'package:simple_networking/services/key_value/model/key_value_response_model.dart';

import '../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../shared/constants.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../add_circle_card/view/add_circle_card.dart';
import '../../key_value/notifier/key_value_notipod.dart';
import 'payment_methods_state.dart';
import 'payment_methods_union.dart';

class PaymentMethodsNotifier extends StateNotifier<PaymentMethodsState> {
  PaymentMethodsNotifier(
    this.read,
    this.cardsIds,
  ) : super(const PaymentMethodsState()) {
    _context = read(sNavigatorKeyPod).currentContext!;
    getCards();
  }

  final Reader read;
  final List<String> cardsIds;
  late BuildContext _context;

  static final _logger = Logger('PaymentMethodsNotifier');

  Future<void> getCards() async {
    _logger.log(notifier, 'getCards');

    _updateUnion(const Loading());

    try {
      final response = await read(circleServicePod).allCards();

      state = state.copyWith(
        cards: response.cards,
      );

      final cardsFailing = response.cards.where(
            (element) => element.status == CircleCardStatus.failed,
      ).toList();
      if (cardsFailing.isNotEmpty &&
          cardsFailing.any((element) => !cardsIds.contains(element.id))) {
        showFailure();
      }
      for (final card in cardsFailing) {
        if (!cardsIds.contains(card.id)) {
          await addCardToKeyValue(card.id);
        }
      }
      _updateUnion(const Success());
    } catch (e) {
      await Future.delayed(const Duration(seconds: 5));
      await getCards();
    }
  }

  void _updateUnion(PaymentMethodsUnion union) {
    state = state.copyWith(union: union);
  }

  Future<void> deleteCard(String cardId) async {
    _logger.log(notifier, 'deleteCard');

    final intl = read(intlPod);

    try {
      final model = DeleteCardRequestModel(cardId: cardId);

      await read(circleServicePod).deleteCard(
        model,
        intl.localeName,
      );

      _deleteCardFromCardsBy(cardId);
    } catch (e) {
      final intl = read(intlPod);

      read(sNotificationNotipod.notifier).showError(
        intl.something_went_wrong_try_again2,
        id: 1,
      );
    }
  }

  void _deleteCardFromCardsBy(String id) {
    state = state.copyWith(
      cards: state.cards.where((card) => card.id != id).toList(),
    );
  }

  Future<void> addCardToKeyValue(String cardId) async {
    _logger.log(notifier, 'addCard');

    try {
      final set = Set.of(cardsIds);
      set.add(cardId);

      await read(keyValueNotipod.notifier).addToKeyValue(
        KeyValueRequestModel(
          keys: [
            KeyValueResponseModel(
              key: cardsKey,
              value: jsonEncode(set.toList()),
            )
          ],
        ),
      );
    } catch (e) {
      _logger.log(stateFlow, 'addCardToKeyValue', e);
    }
  }

  void showFailure() {
    if (!mounted) return;
    final intl = read(intlPod);
    sAnalytics.circleFailed();
    return FailureScreen.push(
      context: _context,
      primaryText: intl.previewBuyWithCircle_failure,
      secondaryText: intl.previewBuyWithCircle_failureDescription,
      primaryButtonName: intl.previewBuyWithCircle_failureAnotherCard,
      onPrimaryButtonTap: () {
        sAnalytics.circleAdd();
        AddCircleCard.pushReplacement(
          context: _context,
          onCardAdded: (card) {
            Navigator.pop(_context);
          },
        );
      },
      secondaryButtonName: intl.previewBuyWithCircle_failureCancel,
      onSecondaryButtonTap: () {
        sAnalytics.circleCancel();
        Navigator.pop(_context);
      },
    );
  }
}
