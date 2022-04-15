import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../models/recurring_buys_model.dart';
import 'recurring_buys_state.dart';

class RecurringBuysNotifier extends StateNotifier<RecurringBuysState> {
  RecurringBuysNotifier(
    this.read,
    this.recurringBuys,
  ) : super(
          const RecurringBuysState(
            recurringBuys: <RecurringBuysModel>[],
          ),
        ) {
    _init();
  }

  final Reader read;
  final List<RecurringBuysModel> recurringBuys;

  static final _logger = Logger('RecurringBuyNotifier');

  void _init() {
    state = state.copyWith(recurringBuys: [...recurringBuys]);
  }

  String total(String asset) {
    var total = 0.0;
    for (final element in state.recurringBuys) {
      if (element.toAsset == asset) {
        total += element.fromAmount!;
      }
    }

    return total.toStringAsFixed(2);
  }

}
