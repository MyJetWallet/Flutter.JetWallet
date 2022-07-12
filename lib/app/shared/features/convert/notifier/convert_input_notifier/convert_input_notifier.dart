import 'package:decimal/decimal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../shared/logging/levels.dart';
import '../../../../helpers/input_helpers.dart';
import '../../../../helpers/truncate_zeros_from.dart';
import '../../../../models/currency_model.dart';
import '../../../../models/selected_percent.dart';
import '../../helper/remove_currency_from_list.dart';
import 'convert_input_state.dart';

class ConvertInputNotifier extends StateNotifier<ConvertInputState> {
  ConvertInputNotifier({
    required this.defaultState,
    required this.currencies,
  }) : super(defaultState);

  final ConvertInputState defaultState;
  final List<CurrencyModel> currencies;

  static final _logger = Logger('ConvertInputNotifier');

  void _updateFromAssetAmount(String value) {
    state = state.copyWith(fromAssetAmount: value);
  }

  void _updateToAssetAmount(String value) {
    state = state.copyWith(toAssetAmount: value);
  }

  void _updateFromAsset(CurrencyModel value) {
    state = state.copyWith(fromAsset: value);
  }

  void _updateToAsset(CurrencyModel value) {
    state = state.copyWith(toAsset: value);
  }

  void _updateConverstionPrice(Decimal? value) {
    state = state.copyWith(converstionPrice: value);
  }

  void _convertValid(bool value) {
    state = state.copyWith(convertValid: value);
  }

  void _updateInputError(InputError error) {
    state = state.copyWith(inputError: error);
  }

  void tapPreset(String presetName) {
    state = state.copyWith(tappedPreset: presetName);
  }

  /// ConversionPrice can be null if request to API failed
  void updateConversionPrice(Decimal? price) {
    _logger.log(notifier, 'updateConversionPrice');

    _updateConverstionPrice(price);
    _calculateConversion();
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

  void updateFromAsset(CurrencyModel value) {
    _logger.log(notifier, 'updateFromAsset');

    updateConversionPrice(null);
    _updateFromAsset(value);
    _updateToList();
    if (state.fromAssetEnabled) {
      _resetAssetsAmount();
    }
    _validateInput();
  }

  void updateToAsset(CurrencyModel value) {
    _logger.log(notifier, 'updateToAsset');

    updateConversionPrice(null);
    _updateToAsset(value);
    _updateFromList();
    if (state.toAssetEnabled) {
      _resetAssetsAmount();
    }
    _validateInput();
  }

  void updateFromAssetAmount(String amount) {
    _logger.log(notifier, 'updateFromAssetAmount');

    _updateFromAssetAmount(
      responseOnInputAction(
        oldInput: state.fromAssetAmount,
        newInput: amount,
        accuracy: state.fromAsset.accuracy,
      ),
    );
    _calculateConversion();
    _validateInput();
    _clearPercent();
  }

  void updateToAssetAmount(String amount) {
    _logger.log(notifier, 'updateToAssetAmount');

    _updateToAssetAmount(
      responseOnInputAction(
        oldInput: state.toAssetAmount,
        newInput: amount,
        accuracy: state.toAsset.accuracy,
      ),
    );
    _calculateConversion();
    _validateInput();
    _clearPercent();
  }

  void enableToAsset() {
    _logger.log(notifier, 'enableToAsset');

    state = state.copyWith(
      toAssetEnabled: true,
      fromAssetEnabled: false,
    );
    _truncateZerosOfAssetAmount();
  }

  void enableFromAsset() {
    _logger.log(notifier, 'enableFromAsset');

    state = state.copyWith(
      toAssetEnabled: false,
      fromAssetEnabled: true,
    );
    _truncateZerosOfAssetAmount();
  }

  /// We can select percent only from FromAssetAmount
  void selectPercentFromBalance(SKeyboardPreset preset) {
    _logger.log(notifier, 'selectPercentFromBalance');

    _updateSelectedPreset(preset);

    final percent = _percentFromPreset(preset);

    if (state.fromAssetEnabled) {
      final value = valueBasedOnSelectedPercent(
        selected: percent,
        currency: state.fromAsset,
      );

      _updateFromAssetAmount(value);
      _calculateConversion();
      _updateAmountsAccordingToAccuracy();
      _validateInput();
    }
  }

  void _updateSelectedPreset(SKeyboardPreset preset) {
    state = state.copyWith(selectedPreset: preset);
  }

  SelectedPercent _percentFromPreset(SKeyboardPreset preset) {
    if (preset == SKeyboardPreset.preset1) {
      return SelectedPercent.pct25;
    } else if (preset == SKeyboardPreset.preset2) {
      return SelectedPercent.pct50;
    } else {
      return SelectedPercent.pct100;
    }
  }

  void _truncateZerosOfAssetAmount() {
    if (state.fromAssetEnabled) {
      _updateToAssetAmount(
        truncateZerosFrom(state.toAssetAmount),
      );
    } else {
      _updateFromAssetAmount(
        truncateZerosFrom(state.fromAssetAmount),
      );
    }
  }

  void _updateAmountsAccordingToAccuracy() {
    _updateFromAssetAmount(
      valueAccordingToAccuracy(
        state.fromAssetAmount,
        state.fromAsset.accuracy,
      ),
    );
    _updateToAssetAmount(
      valueAccordingToAccuracy(
        state.toAssetAmount,
        state.toAsset.accuracy,
      ),
    );
  }

  void _calculateConversion() {
    if (state.converstionPrice != null) {
      if (state.fromAssetEnabled) {
        if (state.fromAssetAmount.isNotEmpty) {
          _calculateConversionOfToAsset();
          _truncateZerosOfAssetAmount();
        } else {
          _resetAssetsAmount();
        }
      } else {
        if (state.toAssetAmount.isNotEmpty) {
          _calculateConversionOfFromAsset();
          _truncateZerosOfAssetAmount();
        } else {
          _resetAssetsAmount();
        }
      }
    }
  }

  void _calculateConversionOfToAsset() {
    final amount = Decimal.parse(state.fromAssetAmount);
    final price = state.converstionPrice!;
    final accuracy = state.toAsset.accuracy;

    final result = amount * price;

    state = state.copyWith(
      toAssetAmount: result.toStringAsFixed(accuracy),
    );
  }

  void _calculateConversionOfFromAsset() {
    final amount = Decimal.parse(state.toAssetAmount);
    final price = state.converstionPrice!;
    final accuracy = state.fromAsset.accuracy;

    var result = Decimal.zero;

    if (price != Decimal.zero) {
      result = (amount / price).toDecimal(
        scaleOnInfinitePrecision: accuracy,
      );
    }

    state = state.copyWith(
      fromAssetAmount: result.toString(),
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
    final error = onTradeInputErrorHandler(
      state.fromAssetAmount,
      state.fromAsset,
    );

    if (error == InputError.none) {
      _convertValid(
        isInputValid(state.fromAssetAmount),
      );
    } else {
      _convertValid(false);
    }

    _updateInputError(error);
  }

  void _updateFromList() {
    final newList = removeCurrencyFromList(state.toAsset, currencies);

    state = state.copyWith(fromAssetList: newList);
  }

  void _updateToList() {
    final newList = removeCurrencyFromList(state.fromAsset, currencies);

    state = state.copyWith(toAssetList: newList);
  }

  void _clearPercent() {
    state = state.copyWith(selectedPreset: null);
  }
}
