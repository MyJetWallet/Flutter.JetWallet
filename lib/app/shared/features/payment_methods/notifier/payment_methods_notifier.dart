import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

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
      await getCards();
    }
  }

  void _updateUnion(PaymentMethodsUnion union) {
    state = state.copyWith(union: union);
  }

  void deleteCard() {}
}
