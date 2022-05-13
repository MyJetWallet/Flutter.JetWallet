import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../service/services/circle/model/delete_card/delete_card_request_model.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import 'payment_methods_state.dart';
import 'payment_methods_union.dart';

class PaymentMethodsNotifier extends StateNotifier<PaymentMethodsState> {
  PaymentMethodsNotifier(this.read) : super(const PaymentMethodsState()) {
    getCards();
  }

  final Reader read;

  static final _logger = Logger('PaymentMethodsNotifier');

  Future<void> getCards() async {
    _logger.log(notifier, 'getCards');

    _updateUnion(const Loading());

    try {
      final response = await read(circleServicePod).allCards();

      state = state.copyWith(
        cards: response.cards,
      );

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

    try {
      final model = DeleteCardRequestModel(cardId: cardId);

      await read(circleServicePod).deleteCard(model);

      _deleteCardFromCardsBy(cardId);
    } catch (e) {
      final intl = read(intlPod);

      read(sNotificationNotipod.notifier).showError(
        intl.error_somethingWentWrongTryAgain,
        id: 1,
      );
    }
  }

  void _deleteCardFromCardsBy(String id) {
    state = state.copyWith(
      cards: state.cards.where((card) => card.id != id).toList(),
    );
  }
}
