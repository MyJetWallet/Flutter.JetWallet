import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../../shared/logging/levels.dart';
import '../../../../../screens/market/model/currency_model.dart';
import '../../../../components/balance_selector/model/selected_percent.dart';
import '../../../../components/number_keyboard/number_keyboard.dart';
import '../../helper/remove_element.dart';
import 'convert_input_state.dart';

const specialPointCase = '0.';

class ConvertInputNotifier extends StateNotifier<ConvertInputState> {
  ConvertInputNotifier({
    required this.defaultState,
    required this.currencies,
  }) : super(defaultState);

  final ConvertInputState defaultState;
  final List<CurrencyModel> currencies;

  static final _logger = Logger('ConvertInputNotifier');

  /// ConversionPrice can be null if request to API failed
  void updateConversionPrice(double? price) {
    _logger.log(notifier, 'updateConversionPrice');

    state = state.copyWith(converstionPrice: price);
    _calculateConversion();
  }

  void updateFromAsset(CurrencyModel currency) {
    _logger.log(notifier, 'updateFromAsset');

    updateConversionPrice(null);
    state = state.copyWith(fromAsset: currency);
    _updateToList();
    _resetAssetsAmount();
  }

  void updateToAsset(CurrencyModel currency) {
    _logger.log(notifier, 'updateToAsset');

    updateConversionPrice(null);
    state = state.copyWith(toAsset: currency);
    _updateFromList();
    _resetAssetsAmount();
  }

  void switchFromAndTo() {
    _logger.log(notifier, 'switchFromAndTo');

    updateConversionPrice(null);

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
    _logger.log(notifier, 'updateFromAssetAmount');

    if (_validInput(amount)) {
      if (amount == backspace) {
        final string = state.fromAssetAmount;

        if (string.isNotEmpty) {
          state = state.copyWith(
            fromAssetAmount: _removeLastCharFrom(string),
          );
        }
      } else {
        final string = state.fromAssetAmount;

        if (amount != period && _firstZeroCase(string)) {
          state = state.copyWith(
            fromAssetAmount: amount,
          );
        } else if (string.isEmpty && amount == period) {
          state = state.copyWith(
            fromAssetAmount: specialPointCase,
          );
        } else {
          state = state.copyWith(
            fromAssetAmount: string + amount,
          );
        }
      }
      _calculateConversion();
      _validateInput();
    }
  }

  void updateToAssetAmount(String amount) {
    _logger.log(notifier, 'updateToAssetAmount');

    if (_validInput(amount)) {
      if (amount == backspace) {
        final string = state.toAssetAmount;

        if (string.isNotEmpty) {
          state = state.copyWith(
            toAssetAmount: _removeLastCharFrom(string),
          );
        }
      } else {
        final string = state.toAssetAmount;

        if (amount != period && _firstZeroCase(string)) {
          state = state.copyWith(
            toAssetAmount: amount,
          );
        } else if (string.isEmpty && amount == period) {
          state = state.copyWith(
            toAssetAmount: specialPointCase,
          );
        } else {
          state = state.copyWith(
            toAssetAmount: string + amount,
          );
        }
      }
      _calculateConversion();
      _validateInput();
    }
  }

  bool _firstZeroCase(String string) {
    return string.length == 1 && string == zero;
  }

  void enableToAsset() {
    _logger.log(notifier, 'enableToAsset');

    state = state.copyWith(
      toAssetEnabled: true,
      fromAssetEnabled: false,
    );
    _trucateZerosOfAssetAmount();
  }

  void enableFromAsset() {
    _logger.log(notifier, 'enableFromAsset');

    state = state.copyWith(
      toAssetEnabled: false,
      fromAssetEnabled: true,
    );
    _trucateZerosOfAssetAmount();
  }

  void _trucateZerosOfAssetAmount() {
    if (state.fromAssetEnabled) {
      if (state.toAssetAmount.isNotEmpty) {
        final number = double.parse(state.toAssetAmount);

        if (number == 0) {
          state = state.copyWith(
            toAssetAmount: '0',
          );
        }
        if (number % 1 == 0) {
          state = state.copyWith(
            toAssetAmount: number.toInt().toString(),
          );
        } else {
          state = state.copyWith(
            toAssetAmount: number.toString(),
          );
        }
      }
    } else {
      if (state.fromAssetAmount.isNotEmpty) {
        final number = double.parse(state.fromAssetAmount);

        if (number == 0) {
          state = state.copyWith(
            fromAssetAmount: '0',
          );
        }
        if (number % 1 == 0) {
          state = state.copyWith(
            fromAssetAmount: number.toInt().toString(),
          );
        } else {
          state = state.copyWith(
            fromAssetAmount: number.toString(),
          );
        }
      }
    }
  }

  void selectPercentFromBalance(SelectedPercent selected) {
    _logger.log(notifier, 'selectPercentFromBalance');

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
      _calculateConversion();
      _updateAmountAccordingToAccuracy();
      _validateInput();
    }
  }

  bool _validInput(String amount) {
    if (amount == period) {
      if (state.fromAssetEnabled) {
        if (state.fromAssetAmount.contains(period)) {
          return false;
        }
      } else {
        if (state.toAssetAmount.contains(period)) {
          return false;
        }
      }
    } else if (amount == backspace) {
      return true;
    } else {
      if (state.fromAssetEnabled) {
        return _fromAssetCharsAfterDecimalValid;
      } else {
        return _toAssetCharsAfterDecimalValid;
      }
    }

    return true;
  }

  bool get _fromAssetCharsAfterDecimalValid {
    return _areCharsAfterDecimalValid(
      state.fromAssetAmount,
      state.fromAsset.accuracy,
    );
  }

  bool get _toAssetCharsAfterDecimalValid {
    return _areCharsAfterDecimalValid(
      state.toAssetAmount,
      state.toAsset.accuracy,
    );
  }

  void _updateAmountAccordingToAccuracy() {
    if (!_fromAssetCharsAfterDecimalValid) {
      final accuracy = state.fromAsset.accuracy;
      final chars = _numberOfCharsAfterDecimal(state.fromAssetAmount);
      final difference = (chars - accuracy).toInt();

      state = state.copyWith(
        fromAssetAmount: _removeCharsFrom(state.fromAssetAmount, difference),
      );
    }

    if (!_toAssetCharsAfterDecimalValid) {
      final accuracy = state.toAsset.accuracy;
      final chars = _numberOfCharsAfterDecimal(state.toAssetAmount);
      final difference = (chars - accuracy).toInt();

      state = state.copyWith(
        toAssetAmount: _removeCharsFrom(state.toAssetAmount, difference),
      );
    }
  }

  bool _areCharsAfterDecimalValid(String string, double accuracy) {
    if (_numberOfCharsAfterDecimal(string) >= accuracy) {
      return false;
    } else {
      return true;
    }
  }

  int _numberOfCharsAfterDecimal(String string) {
    var numbersAfterDecimal = 0;
    var startCount = false;

    for (final char in string.split('')) {
      if (startCount) numbersAfterDecimal++;
      if (char == period) startCount = true;
    }

    return numbersAfterDecimal;
  }

  void _calculateConversion() {
    if (state.converstionPrice != null) {
      if (state.fromAssetEnabled) {
        if (state.fromAssetAmount.isNotEmpty) {
          _calculateConversionOfToAsset();
          _trucateZerosOfAssetAmount();
        } else {
          _resetAssetsAmount();
        }
      } else {
        if (state.toAssetAmount.isNotEmpty) {
          _calculateConversionOfFromAsset();
          _trucateZerosOfAssetAmount();
        } else {
          _resetAssetsAmount();
        }
      }
    }
  }

  void _calculateConversionOfToAsset() {
    final amount = double.parse(state.fromAssetAmount);
    final price = state.converstionPrice!;
    final accuracy = state.toAsset.accuracy.toInt();

    state = state.copyWith(
      toAssetAmount: (amount * price).toStringAsFixed(accuracy),
    );
  }

  void _calculateConversionOfFromAsset() {
    final amount = double.parse(state.toAssetAmount);
    final price = state.converstionPrice!;
    final accuracy = state.fromAsset.accuracy.toInt();

    state = state.copyWith(
      fromAssetAmount: (amount / price).toStringAsFixed(accuracy),
    );
  }

  /// Called when backspace erases everything
  void _resetAssetsAmount() {
    state = state.copyWith(
      fromAssetAmount: '',
      toAssetAmount: '',
    );
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

String _removeCharsFrom(String string, int amount) {
  return string.substring(0, string.length - amount);
}
