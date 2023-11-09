import 'dart:developer';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/market/market_details/helper/currency_from.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
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
import 'package:simple_networking/modules/wallet_api/models/iban_withdrawal/iban_preview_withdrawal_model.dart';
import 'package:simple_networking/modules/wallet_api/models/iban_withdrawal/iban_withdrawal_model.dart';
import 'package:uuid/uuid.dart';

part 'iban_send_amount_store.g.dart';

class IbanSendAmountStore extends _IbanSendAmountStoreBase with _$IbanSendAmountStore {
  IbanSendAmountStore() : super();

  static IbanSendAmountStore of(BuildContext context) => Provider.of<IbanSendAmountStore>(context, listen: false);
}

abstract class _IbanSendAmountStoreBase with Store {
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
  SimpleBankingAccount? account;

  @observable
  InputError withAmmountInputError = InputError.none;

  @observable
  bool showAllWithdraw = true;

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
  Decimal get availableCurrency => Decimal.parse(
        '''${account!.balance!.toDouble() - eurCurrency.cardReserve.toDouble()}''',
      );

  CurrencyModel usdCurrency = currencyFrom(
    sSignalRModules.currenciesList,
    'USD',
  );

  @computed
  SendMethodDto get _sendIbanMethod => sSignalRModules.sendMethods.firstWhere(
        (element) => element.id == WithdrawalMethods.ibanSend,
      );

  @computed
  Decimal? get _minLimit => _sendIbanMethod.symbolNetworkDetails?.firstWhere(
        (element) => element.symbol == eurCurrency.symbol,
        orElse: () {
          return const SymbolNetworkDetails();
        },
      ).minAmount;

  @computed
  Decimal? get _maxLimit => _sendIbanMethod.symbolNetworkDetails?.firstWhere(
        (element) => element.symbol == eurCurrency.symbol,
        orElse: () {
          return const SymbolNetworkDetails();
        },
      ).maxAmount;

  @action
  void init(AddressBookContactModel value, SimpleBankingAccount bankingAccount) {
    contact = value;
    account = bankingAccount;

    requestId = const Uuid().v1();

    sAnalytics.sendEurAmountScreenView();

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
  }

  @action
  Future<void> loadPreview(String description, bool isCJ) async {
    loader.startLoadingImmediately();

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

    loader.finishLoadingImmediately();

    if (!response.hasError) {
      await sRouter.push(
        IbanSendConfirmRouter(
          data: response.data!,
          contact: contact!,
          account: account!,
          previewRequest: previewModel,
          isCJ: isCJ,
        ),
      );
    } else {
      sNotification.showError(
        response.error?.cause ?? '',
        duration: 4,
        id: 1,
        needFeedback: true,
      );
    }
  }

  @action
  void updateAmount(String value) {
    withAmount = responseOnInputAction(
      oldInput: withAmount,
      newInput: value,
      accuracy: eurCurrency.accuracy,
    );

    if (withAmount != zero) {
      showAllWithdraw = false;
    } else {
      showAllWithdraw = true;
    }

    _validateAmount();
    _calculateBaseConversion();
  }

  @action
  void _calculateBaseConversion() {
    if (withAmount.isNotEmpty) {
      final baseValue = calculateBaseBalanceWithReader(
        assetSymbol: eurCurrency.symbol,
        assetBalance: Decimal.parse(withAmount),
      );

      baseConversionValue = truncateZerosFrom(baseValue.toString());
    } else {
      baseConversionValue = zero;
    }
  }

  @action
  void _validateAmount() {
    final error = onEurWithdrawInputErrorHandler(
      withAmount,
      account!.balance!,
      limits,
    );

    final value = Decimal.parse(withAmount);

    if (_minLimit != null && _minLimit! > value) {
      limitError = '${intl.currencyBuy_paymentInputErrorText1} ${volumeFormat(
        decimal: _minLimit!,
        accuracy: eurCurrency.accuracy,
        symbol: eurCurrency.symbol,
      )}';
    } else if (_maxLimit != null && _maxLimit! < value) {
      limitError = '${intl.currencyBuy_paymentInputErrorText2} ${volumeFormat(
        decimal: _maxLimit!,
        accuracy: eurCurrency.accuracy,
        symbol: eurCurrency.symbol,
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
      sAnalytics.errorSendIBANAmount(
        errorCode: withAmmountInputError.toString(),
      );
    }

    withValid = withAmmountInputError == InputError.none && isInputValid(withAmount);
  }
}
