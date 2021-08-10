import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../../shared/logging/levels.dart';
import '../../../../../screens/market/model/currency_model.dart';
import '../../../../components/balance_selector/model/selected_percent.dart';
import '../../../../helpers/input_helpers.dart';
import '../../helper/remove_element.dart';
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

  void _updateConverstionPrice(double? value) {
    state = state.copyWith(converstionPrice: value);
  }

  /// ConversionPrice can be null if request to API failed
  void updateConversionPrice(double? price) {
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
    _resetAssetsAmount();
  }

  void updateToAsset(CurrencyModel value) {
    _logger.log(notifier, 'updateToAsset');

    updateConversionPrice(null);
    _updateToAsset(value);
    _updateFromList();
    _resetAssetsAmount();
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
  void selectPercentFromBalance(SelectedPercent selected) {
    _logger.log(notifier, 'selectPercentFromAvailableBalance');

    if (state.fromAssetEnabled) {
      final value = valueBasedOnSelectedPercent(
        selected: selected,
        currency: state.fromAsset,
      );

      _updateFromAssetAmount(value);
      _calculateConversion();
      _updateAmountsAccordingToAccuracy();
      _validateInput();
    }
  }

  void _truncateZerosOfAssetAmount() {
    if (state.fromAssetEnabled) {
      _updateToAssetAmount(
        truncateZerosFromInput(state.toAssetAmount),
      );
    } else {
      _updateFromAssetAmount(
        truncateZerosFromInput(state.fromAssetAmount),
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
    state = state.copyWith(
      convertValid: isInputValid(state.fromAssetAmount),
    );
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
