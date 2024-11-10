import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/features/withdrawal/store/withdrawal_store.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
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

  @observable
  bool loadingMaxButton = true;

  @action
  void setLoadingMaxButton(bool value) {
    loadingMaxButton = value;
  }

  @observable
  bool onMaxPressed = false;

  @action
  void setInputMode(WithdrawalInputMode value) {
    inputMode = value;
    if (inputMode == WithdrawalInputMode.youSend) {
      isCryptoEntering = true;
    } else {
      isCryptoEntering = false;
    }

    if (isMaxActive) {
      onSendAll();
    } else {
      if (inputMode == WithdrawalInputMode.youSend) {
        baseConversionValue = '0';
      } else {
        withAmount = '0';
      }
    }

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

  @observable
  bool isMaxActive = false;

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

  @computed
  CurrencyModel get mainCurrency => currency != null ? currency! : eurCurrency;

  @computed
  CurrencyModel get secondaryCurrency => currency != null ? eurCurrency : eurCurrency;

  @observable
  bool isCryptoEntering = true;

  @action
  void onSwap() {
    isCryptoEntering = !isCryptoEntering;

    if (isMaxActive) {
      onSendAll();
    }

    _validateAmount();
  }

  @observable
  Decimal feeAmount = Decimal.zero;

  @observable
  Decimal simpleFeeAmount = Decimal.zero;

  @observable
  Decimal? minSellAmount;

  @observable
  Decimal? maxSellAmount;

  @observable
  Decimal? minBuyAmount;

  @observable
  Decimal? maxBuyAmount;

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

  @computed
  SendMethodDto get _sendIbanMethod => sSignalRModules.sendMethods.firstWhere(
        (element) => element.id == WithdrawalMethods.ibanSend,
      );

  @computed
  Decimal? get _minLimit => currency != null
      ? (inputMode == WithdrawalInputMode.youSend ? minSellAmount ?? Decimal.zero : minBuyAmount ?? Decimal.zero)
      : _sendIbanMethod.symbolNetworkDetails?.firstWhere(
          (element) => element.symbol == eurCurrency.symbol,
          orElse: () {
            return const SymbolNetworkDetails();
          },
        ).minAmount;

  @computed
  Decimal? get _maxLimit => currency != null
      ? (inputMode == WithdrawalInputMode.youSend ? maxSellAmount : maxBuyAmount)
      : _sendIbanMethod.symbolNetworkDetails?.firstWhere(
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
    setLoadingMaxButton(true);
    if (currency != null) {
      final model = SellLimitsRequestModel(
        paymentAsset: currency!.symbol,
        buyAsset: eurCurrency.symbol,
        destinationAccountId: contact?.id ?? '',
      );

      final response = await sNetwork.getWalletModule().postSellLimits(model);

      if (response.hasData) {
        minSellAmount = response.data!.minSellAmount;
        maxSellAmount = response.data!.maxSellAmount;

        minBuyAmount = response.data!.minBuyAmount;
        maxBuyAmount = response.data!.maxBuyAmount;
      }
    }
    setLoadingMaxButton(false);
    if (onMaxPressed) {
      onSendAll();
    }
  }

  @action
  Future<void> loadFee(String? description, bool isCJ) async {
    if (currency != null) {
      final model = GetCryptoSellRequestModel(
        buyFixed: true,
        paymentAsset: currency?.symbol ?? '',
        buyAsset: eurCurrency.symbol,
        buyAmount: Decimal.parse('10'),
        paymentAmount: Decimal.parse('10'),
        destinationAccountId: isCJ ? 'clearjuction_account' : account?.accountId ?? '',
        selfWithdrawalData: isCJ
            ? SelfWithdrawalDataModel(
                toIban: contact?.iban ?? '',
                bankCode: contact?.bic ?? '',
              )
            : null,
        personWithdrawalData: isCJ
            ? null
            : PersonWithdrawalDataModel(
                contactId: contact?.id ?? '',
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
    try {
      loader.startLoadingImmediately();

      if (currency != null) {
        final model = GetCryptoSellRequestModel(
          buyFixed: inputMode != WithdrawalInputMode.youSend,
          paymentAsset: currency?.symbol ?? '',
          buyAsset: eurCurrency.symbol,
          buyAmount: Decimal.parse(baseConversionValue),
          paymentAmount: Decimal.parse(withAmount),
          destinationAccountId: isCJ ? 'clearjuction_account' : account?.accountId ?? '',
          selfWithdrawalData: isCJ
              ? SelfWithdrawalDataModel(
                  toIban: contact?.iban ?? '',
                  bankCode: contact?.bic ?? '',
                )
              : null,
          personWithdrawalData: isCJ
              ? null
              : PersonWithdrawalDataModel(
                  contactId: contact?.id ?? '',
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
              account: account!,
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
        loader.finishLoadingImmediately();
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
    } catch (e) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
        needFeedback: true,
      );
    } finally {
      loader.finishLoadingImmediately();
    }
  }

  @action
  void updateAmount(String value) {
    isMaxActive = false;
    if (inputMode == WithdrawalInputMode.youSend) {
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

    _validateAmount();
  }

  @action
  void onSendAll() {
    withAmount = '0';
    baseConversionValue = '0';
    isMaxActive = true;
    onMaxPressed = true;

    if (availableAmount < (maxSellAmount ?? _maxLimit ?? Decimal.zero)) {
      withAmount = responseOnInputAction(
        oldInput: withAmount,
        newInput: inputMode == WithdrawalInputMode.youSend
            ? availableAmount.toString()
            : (availableAmount - feeAmount).toString(),
        accuracy: inputMode == WithdrawalInputMode.youSend ? mainCurrency.accuracy : secondaryCurrency.accuracy,
      );
    } else {
      if (isCryptoEntering) {
        withAmount = responseOnInputAction(
          oldInput: withAmount,
          newInput: (maxSellAmount ?? _maxLimit ?? Decimal.zero).toString(),
          accuracy: mainCurrency.accuracy,
        );
      } else {
        baseConversionValue = responseOnInputAction(
          oldInput: baseConversionValue,
          newInput: (maxBuyAmount ?? _maxLimit ?? Decimal.zero).toString(),
          accuracy: secondaryCurrency.accuracy,
        );
      }
    }

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
      baseConversionValue = '0';
    } else {
      baseConversionValue = value;
      withAmount = '0';
    }

    _validateAmount();
  }

  @action
  void _validateAmount() {
    var error = InputError.none;
    if (inputMode == WithdrawalInputMode.youSend) {
      error = onEurWithdrawInputErrorHandler(
        inputMode == WithdrawalInputMode.youSend ? withAmount : baseConversionValue,
        currency != null ? currency!.assetBalance : account!.balance!,
        limits,
      );
    }

    final value =
        inputMode == WithdrawalInputMode.youSend ? Decimal.parse(withAmount) : Decimal.parse(baseConversionValue);

    print('#@#@#@ 0');
    if (_minLimit != null && _minLimit! > value) {
      print('#@#@#@ 1');
      if (inputMode == WithdrawalInputMode.recepientGets) {
        limitError = '${intl.currencyBuy_paymentInputErrorText1} ${(_minLimit ?? Decimal.zero).toFormatSum(
          accuracy: eurCurrency.accuracy,
          symbol: eurCurrency.symbol,
        )}';
      } else {
        if (currency != null) {
          limitError = '${intl.currencyBuy_paymentInputErrorText1} ${_minLimit?.toFormatCount(
            accuracy: currency!.accuracy,
            symbol: currency!.symbol,
          )}';
        } else {
          limitError = '${intl.currencyBuy_paymentInputErrorText1} ${_minLimit?.toFormatSum(
            accuracy: eurCurrency.accuracy,
            symbol: eurCurrency.symbol,
          )}';
        }
      }
    } else if (_maxLimit != null && _maxLimit! < value) {
      if (inputMode == WithdrawalInputMode.youSend) {
        if (currency != null) {
          limitError = '${intl.currencyBuy_paymentInputErrorText2} ${_maxLimit?.toFormatSum(
            accuracy: currency!.accuracy,
            symbol: currency!.symbol,
          )}';
        } else {
          limitError = '${intl.currencyBuy_paymentInputErrorText2} ${_maxLimit?.toFormatSum(
            accuracy: eurCurrency.accuracy,
            symbol: eurCurrency.symbol,
          )}';
        }
      } else {
        limitError = '${intl.currencyBuy_paymentInputErrorText2} ${_maxLimit?.toFormatCount(
          accuracy: eurCurrency.accuracy,
          symbol: eurCurrency.symbol,
        )}';
      }
    } else {
      limitError = '';
    }

    withAmmountInputError = value != Decimal.zero
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

    print('#@#@#@ $withAmmountInputError');
    withValid = withAmmountInputError == InputError.none && isInputValid(value.toString());
  }
}
