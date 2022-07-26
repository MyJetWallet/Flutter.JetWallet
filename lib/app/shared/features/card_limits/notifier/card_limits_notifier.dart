import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_networking/services/signal_r/model/card_limits_model.dart';

import 'card_limits_state.dart';

class CardLimitsNotifier extends StateNotifier<CardLimitsState> {
  CardLimitsNotifier(
    this.read,
    this.cardLimits,
  ) : super(
          const CardLimitsState(),
        ) {
    cardLimits.whenData(
          (data) {
        state = state.copyWith(
          cardLimits: data,
        );
      },
    );
  }

  final Reader read;
  final AsyncValue<CardLimitsModel> cardLimits;
}
