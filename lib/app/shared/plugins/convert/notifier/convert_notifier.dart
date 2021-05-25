import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../screens/wallet/models/asset_with_balance_model.dart';
import '../helpers/sorted_list_of_currencies.dart';
import 'convert_state.dart';

class ConvertNotifier extends StateNotifier<ConvertState> {
  ConvertNotifier({
    required this.defaultState,
    required this.currencies,
  }) : super(defaultState);

  final ConvertState defaultState;
  final List<AssetWithBalanceModel> currencies;

  void updateFrom(AssetWithBalanceModel from) {
    state = state.copyWith(from: from);
    _updateToList();
  }

  void updateTo(AssetWithBalanceModel to) {
    state = state.copyWith(to: to);
    _updateFromList();
  }

  void switchFromTo() {
    final newFrom = state.to;
    final newTo = state.from;
    final newFromList = List<AssetWithBalanceModel>.from(state.toList);
    final newToList = List<AssetWithBalanceModel>.from(state.fromList);

    state = state.copyWith(
      from: newFrom,
      to: newTo,
      fromList: newFromList,
      toList: newToList,
    );
  }

  void updateAmount(String amount) {
    state.copyWith(amount: int.parse(amount));
  }

  void requestQuote() {
    // TODO
  }

  void convert() {
    // TODO
  }

  void _updateFromList() {
    final newFromList = sortedListOfCurrencies(currencies, state.to);

    state = state.copyWith(fromList: newFromList);
  }

  void _updateToList() {
    final newToList = sortedListOfCurrencies(currencies, state.from);

    state = state.copyWith(toList: newToList);
  }
}
