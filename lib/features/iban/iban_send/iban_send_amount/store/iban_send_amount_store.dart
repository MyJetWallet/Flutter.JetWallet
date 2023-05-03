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
import 'package:jetwallet/utils/models/selected_percent.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/asset_model.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';
import 'package:simple_networking/modules/wallet_api/models/iban_withdrawal/iban_withdrawal_model.dart';

part 'iban_send_amount_store.g.dart';

class IbanSendAmountStore extends _IbanSendAmountStoreBase
    with _$IbanSendAmountStore {
  IbanSendAmountStore() : super();

  static IbanSendAmountStore of(BuildContext context) =>
      Provider.of<IbanSendAmountStore>(context, listen: false);
}

abstract class _IbanSendAmountStoreBase with Store {
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
  AddressBookContactModel? contact;

  @observable
  InputError withAmmountInputError = InputError.none;

  CardLimitsModel? limits;

  StackLoaderStore loader = StackLoaderStore();

  CurrencyModel eurCurrency = currencyFrom(
    sSignalRModules.currenciesList,
    'EUR',
  );

  CurrencyModel usdCurrency = currencyFrom(
    sSignalRModules.currenciesList,
    'USD',
  );

  @action
  void init(AddressBookContactModel value) {
    contact = value;

    final ibanOutMethodInd = eurCurrency.withdrawalMethods.indexWhere(
      (element) => element.id == WithdrawalMethods.ibanSend,
    );

    if (ibanOutMethodInd != -1) {
      limits = CardLimitsModel(
        minAmount: eurCurrency.withdrawalMethods[ibanOutMethodInd].symbolDetails
                ?.last.minAmount ??
            Decimal.zero,
        maxAmount: eurCurrency.withdrawalMethods[ibanOutMethodInd].symbolDetails
                ?.last.maxAmount ??
            Decimal.zero,
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

    log(eurCurrency.toString());
    log(usdCurrency.toString());
  }

  @action
  Future<void> loadPreview() async {
    loader.startLoadingImmediately();

    final model = IbanWithdrawalModel(
      assetSymbol: eurCurrency.symbol,
      amount: Decimal.parse(withAmount),
      lang: intl.localeName,
      contactId: contact?.id ?? '',
      iban: contact?.iban ?? '',
      bic: contact?.bic ?? '',
    );

    final response = await getIt
        .get<SNetwork>()
        .simpleNetworking
        .getWalletModule()
        .postPreviewIbanWithdrawal(model);

    loader.finishLoadingImmediately();

    if (!response.hasError) {
      print(response.data);

      await sRouter.push(
        IbanSendConfirmRouter(
          data: response.data!,
          contact: contact!,
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
  void selectPercentFromBalance(SKeyboardPreset preset) {
    selectedPreset = preset;

    final percent = _percentFromPreset(preset);

    final value = valueBasedOnSelectedPercent(
      selected: percent,
      currency: eurCurrency,
      availableBalance: Decimal.parse(
        '${eurCurrency.assetBalance.toDouble() - eurCurrency.cardReserve.toDouble()}',
      ),
    );

    withAmount = valueAccordingToAccuracy(
      value,
      eurCurrency.accuracy,
    );

    _validateAmount();
    _calculateBaseConversion();
  }

  @action
  void updateAmount(String value) {
    withAmount = responseOnInputAction(
      oldInput: withAmount,
      newInput: value,
      accuracy: eurCurrency.accuracy,
    );

    _validateAmount();
    _calculateBaseConversion();
    selectedPreset = null;
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
    final error = onGloballyWithdrawInputErrorHandler(
      withAmount,
      eurCurrency,
      limits,
    );

    if (limits != null) {
      final value = Decimal.parse(withAmount);

      if (limits!.minAmount > value) {
        limitError = '${intl.currencyBuy_paymentInputErrorText1} ${volumeFormat(
          decimal: limits!.minAmount,
          accuracy: eurCurrency.accuracy,
          symbol: eurCurrency.symbol,
          prefix: eurCurrency.prefixSymbol,
        )}';
      } else if (limits!.maxAmount < value) {
        limitError = '${intl.currencyBuy_paymentInputErrorText2} ${volumeFormat(
          decimal: limits!.maxAmount,
          accuracy: eurCurrency.accuracy,
          symbol: eurCurrency.symbol,
          prefix: eurCurrency.prefixSymbol,
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
