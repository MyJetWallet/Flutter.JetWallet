import 'package:decimal/decimal.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:simple_kit/simple_kit.dart';
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
      limitError = '${intl.currencyBuy_paymentInputErrorText1} ${volumeFormat(
        decimal: _minLimit!,
        accuracy: selectedCurrency.accuracy,
        symbol: selectedCurrency.symbol,
      )}';
    } else if (_maxLimit != null && _maxLimit! < value) {
      limitError = '${intl.currencyBuy_paymentInputErrorText2} ${volumeFormat(
        decimal: _maxLimit!,
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
