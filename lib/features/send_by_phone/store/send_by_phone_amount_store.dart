import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/send_by_phone/model/contact_model.dart';
import 'package:jetwallet/features/send_by_phone/store/send_by_phone_input_store.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/utils/models/selected_percent.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/simple_kit.dart';

part 'send_by_phone_amount_store.g.dart';

class SendByPhoneAmmountStore extends _SendByPhoneAmmountStoreBase
    with _$SendByPhoneAmmountStore {
  SendByPhoneAmmountStore(CurrencyModel currency, ContactModel? pickedContact)
      : super(currency, pickedContact);

  static _SendByPhoneAmmountStoreBase of(BuildContext context) =>
      Provider.of<SendByPhoneAmmountStore>(context, listen: false);
}

abstract class _SendByPhoneAmmountStoreBase with Store {
  _SendByPhoneAmmountStoreBase(
    this.currency,
    this.pickedContact,
  );

  final CurrencyModel currency;

  static final _logger = Logger('SendByPhoneAmountStore');

  @observable
  BaseCurrencyModel? baseCurrency = sSignalRModules.baseCurrency;

  @observable
  SKeyboardPreset? selectedPreset;

  @observable
  String? tappedPreset;

  @observable
  ContactModel? pickedContact;

  @observable
  String amount = '0';

  @observable
  String baseConversionValue = '0';

  @observable
  bool valid = false;

  @observable
  InputError inputError = InputError.none;

  void updateAmount(String value) {
    _logger.log(notifier, 'updateAmount');

    _updateAmount(
      responseOnInputAction(
        oldInput: amount,
        newInput: value,
        accuracy: currency.accuracy,
      ),
    );
    _validateAmount();
    _calculateBaseConversion();
    _clearPercent();
  }

  void selectPercentFromBalance(SKeyboardPreset preset) {
    _logger.log(notifier, 'selectPercentFromBalance');

    _updateSelectedPreset(preset);

    final percent = _percentFromPreset(preset);

    final value = valueBasedOnSelectedPercent(
      selected: percent,
      currency: currency,
      availableBalance: Decimal.parse(
        '${currency.assetBalance.toDouble() - currency.cardReserve.toDouble()}',
      ),
    );

    _updateAmount(
      valueAccordingToAccuracy(value, currency.accuracy),
    );
    _validateAmount();
    _calculateBaseConversion();
  }

  @action
  void tapPreset(String preset) {
    tappedPreset = preset;
  }

  @action
  void _updateSelectedPreset(SKeyboardPreset preset) {
    selectedPreset = preset;
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

  @action
  void _calculateBaseConversion() {
    if (amount.isNotEmpty) {
      final baseValue = calculateBaseBalanceWithReader(
        assetSymbol: currency.symbol,
        assetBalance: Decimal.parse(amount),
      );

      _updateBaseConversionValue(
        truncateZerosFrom(baseValue.toString()),
      );
    } else {
      _updateBaseConversionValue(zero);
    }
  }

  @action
  void _updateBaseConversionValue(String value) {
    baseConversionValue = value;
  }

  @action
  void _validateAmount() {
    final error = onTradeInputErrorHandler(
      amount,
      currency,
    );

    if (error == InputError.none) {
      _updateValid(
        isInputValid(amount),
      );
    } else {
      _updateValid(false);
    }

    _updateInputError(error);
  }

  @action
  void _updateAmount(String value) {
    amount = value;
  }

  @action
  void _updateInputError(InputError error) {
    inputError = error;
  }

  @action
  void _updateValid(bool value) {
    valid = value;
  }

  @action
  void _clearPercent() {
    selectedPreset = null;
  }
}
