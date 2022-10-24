import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_address_store.dart';
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
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';
part 'withdrawal_amount_store.g.dart';

class WithdrawalAmountStore extends _WithdrawalAmountStoreBase
    with _$WithdrawalAmountStore {
  WithdrawalAmountStore(
    WithdrawalModel withdrawal,
    WithdrawalAddressStore addressStore,
  ) : super(withdrawal, addressStore);

  static _WithdrawalAmountStoreBase of(BuildContext context) =>
      Provider.of<WithdrawalAmountStore>(context, listen: false);
}

abstract class _WithdrawalAmountStoreBase with Store {
  _WithdrawalAmountStoreBase(this.withdrawal, this.addressStore) {
    final _address = addressStore;

    tag = _address.tag;
    address = _address.address;
    addressIsInternal = _address.addressIsInternal;
    baseCurrency = sSignalRModules.baseCurrency;
    blockchain = _address.network;

    if (withdrawal.currency != null) {
      currencyModel = withdrawal.currency!;
    } else if (withdrawal.nft != null) {
      nftModel = withdrawal.nft!;
    }
  }

  final WithdrawalModel withdrawal;

  final WithdrawalAddressStore addressStore;

  late CurrencyModel currencyModel;
  late NftMarket nftModel;

  @observable
  BaseCurrencyModel? baseCurrency;

  @observable
  SKeyboardPreset? selectedPreset;

  @observable
  String? tappedPreset;

  @observable
  String tag = '';

  @observable
  String address = '';

  @observable
  String amount = '0';

  @observable
  String baseConversionValue = '0';

  @observable
  bool valid = false;

  @observable
  bool addressIsInternal = false;

  @observable
  BlockchainModel blockchain = const BlockchainModel();

  @observable
  InputError inputError = InputError.none;

  static final _logger = Logger('WithdrawalAmountStore');

  @action
  void updateAmount(String value) {
    _logger.log(notifier, 'updateAmount');

    _updateAmount(
      responseOnInputAction(
        oldInput: amount,
        newInput: value,
        accuracy: currencyModel.accuracy,
      ),
    );
    _validateAmount();
    _calculateBaseConversion();
    _clearPercent();
  }

  @action
  void selectPercentFromBalance(SKeyboardPreset preset) {
    _logger.log(notifier, 'selectPercentFromBalance');

    _updateSelectedPreset(preset);

    final percent = _percentFromPreset(preset);

    final value = valueBasedOnSelectedPercent(
      selected: percent,
      currency: currencyModel,
      availableBalance: Decimal.parse(
        '${currencyModel.assetBalance.toDouble() - currencyModel.cardReserve.toDouble()}',
      ),
    );

    _updateAmount(
      valueAccordingToAccuracy(value, currencyModel.accuracy),
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
        assetSymbol: currencyModel.symbol,
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
    final error = onWithdrawInputErrorHandler(
      amount,
      blockchain.description,
      currencyModel,
      addressIsInternal: addressIsInternal,
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
