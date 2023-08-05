import 'package:decimal/decimal.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/utils/models/selected_percent.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';

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

  @observable
  CurrencyModel selectedCurrency = CurrencyModel.empty();

  @computed
  Decimal get availableCurrency => Decimal.parse(
        '''${selectedCurrency.assetBalance.toDouble() - selectedCurrency.cardReserve.toDouble()}''',
      );

  @computed
  Decimal get _minLimit =>
      selectedCurrency.withdrawalMethods
          .firstWhere((element) => element.id == WithdrawalMethods.internalSend)
          .symbolDetails
          ?.last
          .minAmount ??
      Decimal.zero;

  @computed
  Decimal get _maxLimit =>
      selectedCurrency.withdrawalMethods
          .firstWhere((element) => element.id == WithdrawalMethods.internalSend)
          .symbolDetails
          ?.last
          .maxAmount ??
      Decimal.zero;

  @action
  void init(CurrencyModel newCurrency) {
    selectedCurrency = newCurrency;
    limits = CardLimitsModel(
        minAmount:_minLimit,
        maxAmount: _maxLimit,
        day1Amount: Decimal.zero,
        day1Limit: Decimal.zero,
        day1State: StateLimitType.active,
        day7Amount: Decimal.zero,
        day7Limit: Decimal.zero,
        day7State: StateLimitType.active,
        day30Amount: Decimal.zero,
        day30Limit: Decimal.zero,
        day30State: StateLimitType.active,
        barInterval: StateBarType.day1,
        barProgress: 0,
        leftHours: 0,
      );
  }

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
