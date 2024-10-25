import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';
import 'package:simple_networking/modules/wallet_api/models/banking_withdrawal/banking_withdrawal_preview_model.dart';
import 'package:simple_networking/modules/wallet_api/models/limits/sell_limits_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/sell/get_crypto_sell_request_model.dart';
import 'package:uuid/uuid.dart';

part 'iban_send_amount_store.g.dart';

class IbanSendAmountStore extends _IbanSendAmountStoreBase with _$IbanSendAmountStore {
  IbanSendAmountStore() : super();

  static IbanSendAmountStore of(BuildContext context) => Provider.of<IbanSendAmountStore>(context, listen: false);
}

abstract class _IbanSendAmountStoreBase with Store {
  @observable
  WithdrawalInputMode inputMode = WithdrawalInputMode.youSend;

  @action
  void setInputMode(WithdrawalInputMode value) {
    inputMode = value;
    _validateAmount();
  }

  @observable
  String withAmount = '0';

  @observable
  String baseConversionValue = '0';

  @observable
  String limitError = '';

  @observable
  bool withValid = false;

  @observable
  AddressBookContactModel? contact;

  @observable
  bool? isCJAcc;

  @observable
  SimpleBankingAccount? account;

  @observable
  CurrencyModel? currency;

  @observable
  InputError withAmmountInputError = InputError.none;

  var requestId = '';

  CardLimitsModel? limits;

  StackLoaderStore loader = StackLoaderStore();

  @computed
  ObservableList<CurrencyModel> get _allAssets {
    return sSignalRModules.currenciesList;
  }

  @computed
  CurrencyModel get eurCurrency => currencyFrom(
        _allAssets,
        'EUR',
      );

  @computed
  Decimal get availableAmount {
    if (currency != null) {
      return currency!.assetBalance;
    } else {
      return Decimal.parse(
        '''${account!.balance!.toDouble() - eurCurrency.cardReserve.toDouble()}''',
      );
    }
  }

  final CurrencyModel _baseCurrency = currencyFrom(
    sSignalRModules.currenciesList,
    sSignalRModules.baseCurrency.symbol,
  );

  @computed
  CurrencyModel get mainCurrency => currency != null ? currency! : eurCurrency;

  @computed
  CurrencyModel get secondaryCurrency => currency != null ? _baseCurrency : eurCurrency;

  @observable
  bool isCryptoEntering = true;

  @action
  void onSwap() {
    isCryptoEntering = !isCryptoEntering;

    _validateAmount();
  }

  @observable
  Decimal feeAmount = Decimal.zero;

  @observable
  Decimal simpleFeeAmount = Decimal.zero;

  @observable
  Decimal? minAmount;

  @observable
  Decimal? maxAmount;

  @computed
  String get primaryAmount {
    return isCryptoEntering ? withAmount : baseConversionValue;
  }

  @computed
  String get primarySymbol {
    return isCryptoEntering ? mainCurrency.symbol : secondaryCurrency.symbol;
  }

  @computed
  String get secondaryAmount {
    return isCryptoEntering ? baseConversionValue : withAmount;
  }

  @computed
  String get secondarySymbol {
    return isCryptoEntering ? secondaryCurrency.symbol : mainCurrency.symbol;
  }

  @computed
  int get primaryAccuracy {
    return isCryptoEntering ? mainCurrency.accuracy : secondaryCurrency.accuracy;
  }

  @computed
  int get secondaryAccuracy {
    return isCryptoEntering ? secondaryCurrency.accuracy : mainCurrency.accuracy;
  }

  @action
  void _calculateBaseConversion() {
    if (withAmount.isNotEmpty) {
      final baseValue = calculateBaseBalanceWithReader(
        assetSymbol: mainCurrency.symbol,
        assetBalance: Decimal.parse(withAmount),
      );

      baseConversionValue = truncateZerosFrom(
        baseValue.toStringAsFixed(secondaryAccuracy),
      );
    } else {
      baseConversionValue = zero;
    }
  }

  @action
  void _calculateCryptoConversion() {
    final amount = getIt.get<FormatService>().convertOneCurrencyToAnotherOne(
          fromCurrency: sSignalRModules.baseCurrency.symbol,
          fromCurrencyAmmount: Decimal.parse(baseConversionValue),
          toCurrency: mainCurrency.symbol,
          baseCurrency: sSignalRModules.baseCurrency.symbol,
          isMin: false,
        );

    withAmount = truncateZerosFrom(
      amount.toStringAsFixed(primaryAccuracy),
    );
  }

  @computed
  SendMethodDto get _sendIbanMethod => sSignalRModules.sendMethods.firstWhere(
        (element) => element.id == WithdrawalMethods.ibanSend,
      );

  @computed
  Decimal? get _minLimit =>
      minAmount ??
      _sendIbanMethod.symbolNetworkDetails?.firstWhere(
        (element) => element.symbol == eurCurrency.symbol,
        orElse: () {
          return const SymbolNetworkDetails();
        },
      ).minAmount;

  @computed
  Decimal? get _maxLimit =>
      maxAmount ??
      _sendIbanMethod.symbolNetworkDetails?.firstWhere(
        (element) => element.symbol == eurCurrency.symbol,
        orElse: () {
          return const SymbolNetworkDetails();
        },
      ).maxAmount;

  @action
  void init({
    required AddressBookContactModel value,
    required bool isCJ,
    required SimpleBankingAccount? bankingAccount,
    required CurrencyModel? currencyModel,
  }) {
    contact = value;
    isCJAcc = isCJ;

    account = bankingAccount;
    currency = currencyModel;

    requestId = const Uuid().v1();

    sAnalytics.eurWithdrawEurAmountSV(
      isCJ: isCJ,
      accountIban: bankingAccount?.iban ?? '',
      accountLabel: bankingAccount?.label ?? '',
      eurAccType: value.iban ?? '',
      eurAccLabel: value.name ?? '',
    );

    final ibanOutMethodInd = eurCurrency.withdrawalMethods.indexWhere(
      (element) => element.id == WithdrawalMethods.ibanSend,
    );

    if (ibanOutMethodInd != -1) {
      limits = CardLimitsModel(
        minAmount: _minLimit ?? Decimal.zero,
        maxAmount: _maxLimit ?? Decimal.zero,
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

    loadFee('Get fee', isCJ);
    loadLimits();
  }

  @action
  Future<void> loadLimits() async {
    if (currency != null) {
      final model = SellLimitsRequestModel(
        paymentAsset: currency!.symbol,
        buyAsset: eurCurrency.symbol,
        destinationAccountId: contact?.id ?? '',
      );

      final response = await sNetwork.getWalletModule().postSellLimits(model);

      if (response.hasData) {
        minAmount = response.data!.minSellAmount;
        maxAmount = response.data!.maxSellAmount;
      }
    }
  }

  @action
  Future<void> loadFee(String? description, bool isCJ) async {
    if (currency != null) {
      final accounts = sSignalRModules.bankingProfileData?.banking?.accounts ?? [];

      final model = GetCryptoSellRequestModel(
        buyFixed: true,
        paymentAsset: currency?.symbol ?? '',
        buyAsset: eurCurrency.symbol,
        buyAmount: Decimal.parse('10'),
        paymentAmount: Decimal.parse('10'),
        destinationAccountId: isCJ ? 'clearjuction_account' : accounts.first.accountId ?? '',
        selfWithdrawalData: isCJ
            ? SelfWithdrawalDataModel(
                toIban: contact?.iban ?? '',
                bankCode: contact?.bic ?? '',
              )
            : null,
        personWithdrawalData: isCJ
            ? null
            : PersonWithdrawalDataModel(
                toIban: contact?.iban ?? '',
                beneficiaryName: contact?.name ?? '',
                beneficiaryAddress: '',
                beneficiaryCountry: contact?.bankCountry ?? '',
                bankCode: contact?.bic ?? '',
                intermediaryBankCode: '',
                intermediaryBankAccount: '',
              ),
      );

      final response = await sNetwork.getWalletModule().postSellCreate(model);

      if (response.hasData) {
        feeAmount = response.data!.tradeFeeAmount;
      }
    } else {
      final previewModel = BankingWithdrawalPreviewModel(
        accountId: account?.accountId ?? '',
        requestId: const Uuid().v1(),
        toIbanAddress: contact?.iban ?? '',
        assetSymbol: eurCurrency.symbol,
        amount: Decimal.parse(withAmount),
        contactId: contact?.id ?? '',
        beneficiaryBankCode: contact?.bic ?? '',
        description: description,
        expressPayment: false,
      );

      final response =
          await getIt.get<SNetwork>().simpleNetworking.getWalletModule().postBankingWithdrawalPreview(previewModel);

      if (response.hasData) {
        feeAmount = response.data!.feeAmount ?? Decimal.zero;
        simpleFeeAmount = response.data!.simpleFeeAmount ?? Decimal.zero;
      }
    }
  }

  @action
  Future<void> loadPreview(String? description, bool isCJ) async {
    loader.startLoadingImmediately();

    if (currency != null) {
      final accounts = sSignalRModules.bankingProfileData?.banking?.accounts ?? [];

      final model = GetCryptoSellRequestModel(
        buyFixed: inputMode != WithdrawalInputMode.youSend,
        paymentAsset: currency?.symbol ?? '',
        buyAsset: eurCurrency.symbol,
        buyAmount: Decimal.parse(baseConversionValue),
        paymentAmount: Decimal.parse(withAmount),
        destinationAccountId: isCJ ? 'clearjuction_account' : accounts.first.accountId ?? '',
        selfWithdrawalData: isCJ
            ? SelfWithdrawalDataModel(
                toIban: contact?.iban ?? '',
                bankCode: contact?.bic ?? '',
              )
            : null,
        personWithdrawalData: isCJ
            ? null
            : PersonWithdrawalDataModel(
                toIban: contact?.iban ?? '',
                beneficiaryName: contact?.name ?? '',
                beneficiaryAddress: '',
                beneficiaryCountry: contact?.bankCountry ?? '',
                bankCode: contact?.bic ?? '',
                intermediaryBankCode: '',
                intermediaryBankAccount: '',
              ),
      );

      final response = await sNetwork.getWalletModule().postSellCreate(model);

      if (response.hasData) {
        final previewModel = BankingWithdrawalPreviewModel(
          accountId: account?.accountId ?? '',
          requestId: const Uuid().v1(),
          toIbanAddress: contact?.iban ?? '',
          assetSymbol: eurCurrency.symbol,
          amount: Decimal.parse(withAmount),
          contactId: contact?.id ?? '',
          beneficiaryBankCode: contact?.bic ?? '',
          description: description,
          expressPayment: false,
        );

        await sRouter.push(
          IbanSendConfirmRouter(
            data: null,
            previewRequest: previewModel,
            contact: contact!,
            account: accounts.first,
            isCJ: isCJ,
            cryptoSell: response.data,
          ),
        );
      } else {
        sNotification.showError(
          response.error?.cause ?? intl.something_went_wrong,
          id: 1,
          needFeedback: true,
        );
      }
    } else {
      final previewModel = BankingWithdrawalPreviewModel(
        accountId: account?.accountId ?? '',
        requestId: requestId,
        toIbanAddress: contact?.iban ?? '',
        assetSymbol: eurCurrency.symbol,
        amount: Decimal.parse(withAmount),
        contactId: contact?.id ?? '',
        beneficiaryBankCode: contact?.bic ?? '',
        description: description,
        expressPayment: false,
      );

      final response =
          await getIt.get<SNetwork>().simpleNetworking.getWalletModule().postBankingWithdrawalPreview(previewModel);

      if (!response.hasError) {
        await sRouter
            .push(
          IbanSendConfirmRouter(
            data: response.data,
            contact: contact!,
            account: account!,
            previewRequest: previewModel,
            isCJ: isCJ,
            cryptoSell: null,
          ),
        )
            .then((value) {
          sAnalytics.eurWithdrawTapBackOrderSummary(
            isCJ: isCJAcc!,
            accountIban: account?.iban ?? '',
            accountLabel: account?.label ?? '',
            eurAccType: contact?.iban ?? '',
            eurAccLabel: contact?.name ?? '',
            enteredAmount: withAmount,
          );
        });
      } else {
        sNotification.showError(
          response.error?.cause ?? intl.something_went_wrong,
          id: 1,
          needFeedback: true,
        );
      }
    }

    loader.finishLoadingImmediately();
  }

  @action
  void updateAmount(String value) {
    if (isCryptoEntering) {
      withAmount = responseOnInputAction(
        oldInput: withAmount,
        newInput: value,
        accuracy: mainCurrency.accuracy,
      );
    } else {
      baseConversionValue = responseOnInputAction(
        oldInput: baseConversionValue,
        newInput: value,
        accuracy: sSignalRModules.baseCurrency.accuracy,
      );
    }

    if (isCryptoEntering) {
      _calculateBaseConversion();
    } else {
      _calculateCryptoConversion();
    }
    _validateAmount();
  }

  @action
  void onSendAll() {
    withAmount = '0';
    var sendAllValue = '';
    if (availableAmount > (_maxLimit ?? Decimal.zero)) {
      sendAllValue = responseOnInputAction(
        oldInput: withAmount,
        newInput: inputMode == WithdrawalInputMode.youSend
            ? availableAmount.toString()
            : (availableAmount - feeAmount).toString(),
        accuracy: mainCurrency.accuracy,
      );
    } else {
      sendAllValue = responseOnInputAction(
        oldInput: withAmount,
        newInput: inputMode == WithdrawalInputMode.youSend
            ? _maxLimit.toString()
            : ((_maxLimit ?? availableAmount) - feeAmount).toString(),
        accuracy: mainCurrency.accuracy,
      );
    }

    if (Decimal.parse(sendAllValue) < Decimal.zero) {
      withAmount = '0';
    } else {
      withAmount = sendAllValue;
    }

    isCryptoEntering = true;

    _calculateBaseConversion();

    _validateAmount();
  }

  @computed
  Decimal get recepientGetsAmount {
    Decimal result;
    if (inputMode == WithdrawalInputMode.recepientGets) {
      result = Decimal.parse(withAmount);
    } else {
      result = Decimal.parse(withAmount) - feeAmount;
    }
    return result >= Decimal.zero ? result : Decimal.zero;
  }

  @computed
  Decimal get youSendAmount {
    if (withAmount == '0') return Decimal.zero;

    Decimal result;
    if (inputMode == WithdrawalInputMode.youSend) {
      result = Decimal.parse(withAmount);
    } else {
      result = Decimal.parse(withAmount) + feeAmount;
    }
    return result >= Decimal.zero ? result : Decimal.zero;
  }

  @action
  void pasteAmount(String value) {
    if (isCryptoEntering) {
      withAmount = value;
    } else {
      baseConversionValue = value;
    }

    if (isCryptoEntering) {
      _calculateBaseConversion();
    } else {
      _calculateCryptoConversion();
    }

    _validateAmount();
  }

  @action
  void _validateAmount() {
    final fee = feeAmount + simpleFeeAmount;

    final error = onEurWithdrawInputErrorHandler(
      isCryptoEntering ? withAmount : baseConversionValue,
      currency != null ? currency!.assetBalance : account!.balance!,
      limits,
    );

    final value = Decimal.parse(withAmount);

    if (_minLimit != null && _minLimit! > value) {
      if (inputMode == WithdrawalInputMode.recepientGets) {
        limitError = '${intl.currencyBuy_paymentInputErrorText1} ${((_minLimit ?? Decimal.zero) - fee).toFormatCount(
          accuracy: currency != null ? currency!.accuracy : eurCurrency.accuracy,
          symbol: currency != null ? currency!.symbol : eurCurrency.symbol,
        )}';
      } else {
        limitError = '${intl.currencyBuy_paymentInputErrorText1} ${_minLimit?.toFormatCount(
          accuracy: currency != null ? currency!.accuracy : eurCurrency.accuracy,
          symbol: currency != null ? currency!.symbol : eurCurrency.symbol,
        )}';
      }
    } else if (_maxLimit != null && _maxLimit! < value) {
      limitError = '${intl.currencyBuy_paymentInputErrorText2} ${_maxLimit?.toFormatCount(
        accuracy: currency != null ? currency!.accuracy : eurCurrency.accuracy,
        symbol: currency != null ? currency!.symbol : eurCurrency.symbol,
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

    if (error != InputError.none) {
      sAnalytics.eurWithdrawErrorShowConvert(
        isCJ: isCJAcc!,
        accountIban: account?.iban ?? '',
        accountLabel: account?.label ?? '',
        eurAccType: contact?.iban ?? '',
        eurAccLabel: contact?.name ?? '',
        errorText: withAmmountInputError.toString(),
        enteredAmount: withAmount,
      );
    }

    withValid = withAmmountInputError == InputError.none && isInputValid(withAmount);
  }
}
