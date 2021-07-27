import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../screens/market/model/currency_model.dart';
import '../../../../components/balance_selector/model/selected_percent.dart';
import '../../../../components/number_keyboard/number_keyboard.dart';
import '../../helper/remove_element.dart';
import 'convert_input_state.dart';

class ConvertInputNotifier extends StateNotifier<ConvertInputState> {
  ConvertInputNotifier({
    required this.defaultState,
    required this.currencies,
  }) : super(defaultState);

  final ConvertInputState defaultState;
  final List<CurrencyModel> currencies;

  void updateFromAsset(CurrencyModel currency) {
    state = state.copyWith(fromAsset: currency);
    _updateToList();
  }

  void updateToAsset(CurrencyModel currency) {
    state = state.copyWith(toAsset: currency);
    _updateFromList();
  }

  void switchFromAndTo() {
    final fromAsset = state.toAsset;
    final toAsset = state.fromAsset;
    final fromList = List<CurrencyModel>.from(state.toAssetList);
    final toList = List<CurrencyModel>.from(state.fromAssetList);
    final fromAmount = state.toAssetAmount;
    final toAmount = state.fromAssetAmount;

    state = state.copyWith(
      fromAsset: fromAsset,
      toAsset: toAsset,
      fromAssetList: fromList,
      toAssetList: toList,
      fromAssetAmount: fromAmount,
      toAssetAmount: toAmount,
    );
    _validateInput();
  }

  void updateFromAssetAmount(String amount) {
    if (amount == backspace) {
      final string = state.fromAssetAmount;

      if (string.isNotEmpty) {
        state = state.copyWith(
          fromAssetAmount: _removeLastCharFrom(string),
        );
      }
    } else {
      state = state.copyWith(
        fromAssetAmount: state.fromAssetAmount + amount,
      );
    }
    _validateInput();
  }

  void updateToAssetAmount(String amount) {
    if (amount == backspace) {
      final string = state.toAssetAmount;

      if (string.isNotEmpty) {
        state = state.copyWith(
          toAssetAmount: _removeLastCharFrom(string),
        );
      }
    } else {
      state = state.copyWith(
        toAssetAmount: state.toAssetAmount + amount,
      );
    }
    _validateInput();
  }

  void enableToAsset() {
    state = state.copyWith(
      toAssetEnabled: true,
      fromAssetEnabled: false,
    );
  }

  void enableFromAsset() {
    state = state.copyWith(
      toAssetEnabled: false,
      fromAssetEnabled: true,
    );
  }

  void selectPercentFromBalance(SelectedPercent selected) {
    final fromAsset = state.fromAsset;

    if (state.fromAssetEnabled) {
      if (fromAsset.isAssetBalanceEmpty) {
        state = state.copyWith(fromAssetAmount: '0');
      } else if (selected == SelectedPercent.pct25) {
        final value = fromAsset.assetBalance * 0.25;
        state = state.copyWith(fromAssetAmount: '$value');
      } else if (selected == SelectedPercent.pct50) {
        final value = fromAsset.assetBalance * 0.50;
        state = state.copyWith(fromAssetAmount: '$value');
      } else if (selected == SelectedPercent.pct100) {
        final value = fromAsset.assetBalance;
        state = state.copyWith(fromAssetAmount: '$value');
      }
    }
    _validateInput();
  }

  void _validateInput() {
    if (state.fromAssetAmount.isEmpty) {
      state = state.copyWith(convertValid: false);
    } else {
      final value = double.parse(state.fromAssetAmount);

      if (value == 0) {
        state = state.copyWith(convertValid: false);
      } else {
        state = state.copyWith(convertValid: true);
      }
    }
  }

  void _updateFromList() {
    final newList = removeElement(state.toAsset, currencies);

    state = state.copyWith(fromAssetList: newList);
  }

  void _updateToList() {
    final newList = removeElement(state.fromAsset, currencies);

    state = state.copyWith(toAssetList: newList);
  }
}

String _removeLastCharFrom(String string) {
  return string.substring(0, string.length - 1);
}
