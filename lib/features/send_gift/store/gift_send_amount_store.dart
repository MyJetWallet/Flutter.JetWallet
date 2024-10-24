import 'package:decimal/decimal.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

part 'gift_send_amount_store.g.dart';

class GeftSendAmountStore extends _GeftSendAmountStoreBase with _$GeftSendAmountStore {
  GeftSendAmountStore() : super();
}

abstract class _GeftSendAmountStoreBase with Store {
  _GeftSendAmountStoreBase() {
    reaction(
      (_) => selectedCurrency,
      (msg) {
        refresh();
      },
    );
  }

  @observable
  String withAmount = '0';

  @computed
  BaseCurrencyModel get baseCurrency => sSignalRModules.baseCurrency;

  @observable
  String baseConversionValue = '0';

  @observable
  String limitError = '';

  @observable
  bool withValid = false;

  @observable
  InputError withAmmountInputError = InputError.none;

  @observable
  String? sendCurrencyAsset;

  @computed
  CurrencyModel get selectedCurrency => sendCurrencyAsset != null
      ? currencyFrom(
          sSignalRModules.currenciesList,
          sendCurrencyAsset!,
        )
      : CurrencyModel.empty();

  @computed
  Decimal get availableCurrency => Decimal.parse(
        '''${selectedCurrency.assetBalance.toDouble() - selectedCurrency.cardReserve.toDouble()}''',
      );

  @computed
  SendMethodDto get _sendGiftMethod => sSignalRModules.sendMethods.firstWhere(
        (element) => element.id == WithdrawalMethods.internalSend,
      );

  @computed
  Decimal? get _minLimit => _sendGiftMethod.symbolNetworkDetails?.firstWhere(
        (element) => element.symbol == selectedCurrency.symbol,
        orElse: () {
          return const SymbolNetworkDetails();
        },
      ).minAmount;

  @computed
  Decimal? get _maxLimit => _sendGiftMethod.symbolNetworkDetails?.firstWhere(
        (element) => element.symbol == selectedCurrency.symbol,
        orElse: () {
          return const SymbolNetworkDetails();
        },
      ).maxAmount;

  @action
  void init(CurrencyModel newCurrency) {
    sendCurrencyAsset = newCurrency.symbol;
  }

  @action
  void refresh() {
    _validateAmount();
    _calculateBaseConversion();
  }

  @computed
  Decimal get sendAllValue {
    final balance = selectedCurrency.assetBalance;
    final limit = _maxLimit ?? Decimal.zero;
    return balance < limit ? balance : limit;
  }

  @action
  void onSandAll() {
    withAmount = '0';
    withAmount = responseOnInputAction(
      oldInput: withAmount,
      newInput: sendAllValue.toString(),
      accuracy: selectedCurrency.accuracy,
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
  }

  @action
  void pasteAmount(String value) {
    withAmount = value;

    _validateAmount();
    _calculateBaseConversion();
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
      null,
    );

    final value = Decimal.parse(withAmount);

    if (_minLimit != null && _minLimit! > value) {
      limitError = '${intl.currencyBuy_paymentInputErrorText1} ${_minLimit?.toFormatCount(
        accuracy: selectedCurrency.accuracy,
        symbol: selectedCurrency.symbol,
      )}';
    } else if (_maxLimit != null && _maxLimit! < value) {
      limitError = '${intl.currencyBuy_paymentInputErrorText2} ${_maxLimit?.toFormatCount(
        accuracy: selectedCurrency.accuracy,
        symbol: selectedCurrency.symbol,
      )}';
    } else {
      limitError = '';
    }

    withAmmountInputError = double.parse(withAmount) != 0
        ? error == InputError.none
            ? limitError.isEmpty
                ? InputError.none
                : InputError.limitError
            : error
        : InputError.none;

    withValid = error == InputError.none && isInputValid(withAmount);
  }
}
