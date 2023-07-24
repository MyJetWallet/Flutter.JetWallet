import 'package:decimal/decimal.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/utils/models/selected_percent.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';

part 'gift_send_amount_store.g.dart';

class GeftSendAmountStore extends _GeftSendAmountStoreBase
    with _$GeftSendAmountStore {
  GeftSendAmountStore() : super();
}

abstract class _GeftSendAmountStoreBase with Store {
  @observable
  SKeyboardPreset? selectedPreset;
  @observable
  String? tappedPreset;
  @action
  void tapPreset(String preset) => tappedPreset = preset;

  @observable
  String withAmount = '0';

  @observable
  String baseConversionValue = '0';

  @observable
  String limitError = '';

  @observable
  bool withValid = false;

  @observable
  InputError withAmmountInputError = InputError.none;

  CardLimitsModel? limits;

  StackLoaderStore loader = StackLoaderStore();

  @observable
  CurrencyModel selectedCurrency = CurrencyModel.empty();

  @computed
  Decimal get availableCurrency => Decimal.parse(
        '''${selectedCurrency.assetBalance.toDouble() - selectedCurrency.cardReserve.toDouble()}''',
      );

  @action
  void selectPercentFromBalance(SKeyboardPreset preset) {
    selectedPreset = preset;

    final percent = _percentFromPreset(preset);

    final value = valueBasedOnSelectedPercent(
      selected: percent,
      currency: selectedCurrency,
      availableBalance: Decimal.parse(
        '${selectedCurrency.assetBalance.toDouble() - selectedCurrency.cardReserve.toDouble()}',
      ),
    );

    withAmount = valueAccordingToAccuracy(
      value,
      selectedCurrency.accuracy,
    );

    _validateAmount();
    _calculateBaseConversion();
  }

  @action
  void updateAmount(String value) {
    withAmount = responseOnInputAction(
      oldInput: withAmount,
      newInput: value,
      accuracy: selectedCurrency.accuracy,
    );

    _validateAmount();
    _calculateBaseConversion();
    selectedPreset = null;
  }

  @action
  void _calculateBaseConversion() {
    if (withAmount.isNotEmpty) {
      final baseValue = calculateBaseBalanceWithReader(
        assetSymbol: selectedCurrency.symbol,
        assetBalance: Decimal.parse(withAmount),
      );

      baseConversionValue = truncateZerosFrom(baseValue.toString());
    } else {
      baseConversionValue = zero;
    }
  }

  @action
  void _validateAmount() {
    final error = onGloballyWithdrawInputErrorHandler(
      withAmount,
      selectedCurrency,
      limits,
    );

    if (limits != null) {
      final value = Decimal.parse(withAmount);

      if (limits!.minAmount > value) {
        limitError = '${intl.currencyBuy_paymentInputErrorText1} ${volumeFormat(
          decimal: limits!.minAmount,
          accuracy: selectedCurrency.accuracy,
          symbol: selectedCurrency.symbol,
          prefix: selectedCurrency.prefixSymbol,
        )}';
      } else if (limits!.maxAmount < value) {
        limitError = '${intl.currencyBuy_paymentInputErrorText2} ${volumeFormat(
          decimal: limits!.maxAmount,
          accuracy: selectedCurrency.accuracy,
          symbol: selectedCurrency.symbol,
          prefix: selectedCurrency.prefixSymbol,
        )}';
      } else {
        limitError = '';
      }
    }

    withAmmountInputError = double.parse(withAmount) != 0
        ? error == InputError.none
            ? limitError.isEmpty
                ? InputError.none
                : InputError.limitError
            : error
        : InputError.none;

    withValid = error == InputError.none ? isInputValid(withAmount) : false;
  }

  @action
  SelectedPercent _percentFromPreset(SKeyboardPreset preset) {
    if (preset == SKeyboardPreset.preset1) {
      return SelectedPercent.pct25;
    } else if (preset == SKeyboardPreset.preset2) {
      return SelectedPercent.pct50;
    } else {
      return SelectedPercent.pct100;
    }
  }
}
