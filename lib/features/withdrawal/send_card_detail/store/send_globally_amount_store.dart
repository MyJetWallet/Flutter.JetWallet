import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/signal_r/models/global_send_methods_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/send_globally/send_to_bank_request_model.dart';

part 'send_globally_amount_store.g.dart';

class SendGloballyAmountStore extends _SendGloballyAmountStoreBase with _$SendGloballyAmountStore {
  SendGloballyAmountStore() : super();

  static SendGloballyAmountStore of(BuildContext context) =>
      Provider.of<SendGloballyAmountStore>(context, listen: false);
}

abstract class _SendGloballyAmountStoreBase with Store {
  @observable
  String? sendCurrencyAsset;
  @computed
  CurrencyModel? get sendCurrency => sendCurrencyAsset != null
      ? currencyFrom(
          sSignalRModules.currenciesList,
          sendCurrencyAsset!,
        )
      : null;

  @observable
  String countryCode = '';
  @observable
  String cardNumber = '';
  @observable
  CircleCardNetwork cardNetwork = CircleCardNetwork.unsupported;

  @observable
  Decimal minLimitAmount = Decimal.zero;

  @observable
  Decimal maxLimitAmount = Decimal.zero;

  @observable
  String limitError = '';

  SendToBankRequestModel? mainData;
  GlobalSendMethodsModelMethods? method;

  @action
  void setCardNumber(
    SendToBankRequestModel data,
    GlobalSendMethodsModelMethods m,
  ) {
    sendCurrencyAsset = data.asset ?? '';
    countryCode = data.countryCode ?? '';

    mainData = data;
    method = m;

    final minLim = getIt<FormatService>().convertOneCurrencyToAnotherOne(
      fromCurrency: method!.receiveAsset!,
      fromCurrencyAmmount: method!.minAmount!,
      toCurrency: sendCurrency!.symbol,
      baseCurrency: baseCurrency.symbol,
      isMin: true,
    );
    final maxLim = getIt<FormatService>().convertOneCurrencyToAnotherOne(
      fromCurrency: method!.receiveAsset!,
      fromCurrencyAmmount: method!.maxAmount!,
      toCurrency: sendCurrency!.symbol,
      baseCurrency: baseCurrency.symbol,
      isMin: false,
    );

    final minLimRounded = getIt<FormatService>().smartRound(
      number: minLim,
      toCurrency: sendCurrency!.symbol,
      isMin: true,
    );
    final maxLimRounded = getIt<FormatService>().smartRound(
      number: maxLim,
      toCurrency: sendCurrency!.symbol,
      isMin: false,
    );

    if (minLimRounded >= maxLimRounded) {
      minLimitAmount = minLim;
      maxLimitAmount = maxLim;
    } else {
      minLimitAmount = getIt<FormatService>().smartRound(
        number: minLim,
        toCurrency: sendCurrency!.symbol,
        isMin: true,
      );
      maxLimitAmount = getIt<FormatService>().smartRound(
        number: maxLim,
        toCurrency: sendCurrency!.symbol,
        isMin: false,
      );
    }

    if (data.cardNumber != null && data.cardNumber!.isNotEmpty) {
      if (data.cardNumber![0] == '4') {
        cardNetwork = CircleCardNetwork.VISA;
      } else if (data.cardNumber![0] == '5') {
        cardNetwork = CircleCardNetwork.MASTERCARD;
      }
    }
  }

  @observable
  String withAmount = '0';

  @observable
  String baseConversionValue = '0';

  @observable
  bool withValid = false;

  @observable
  InputError withAmmountInputError = InputError.none;

  @computed
  BaseCurrencyModel get baseCurrency => sSignalRModules.baseCurrency;

  StackLoaderStore loader = StackLoaderStore();

  @computed
  Decimal get availableBalabce => Decimal.parse(
        '''${sendCurrency!.assetBalance.toDouble() - sendCurrency!.cardReserve.toDouble()}''',
      );

  @action
  Future<void> loadPreview() async {
    loader.startLoadingImmediately();

    mainData = mainData!.copyWith(
      amount: Decimal.parse(withAmount),
      methodId: method!.methodId ?? '',
    );

    final response = await getIt.get<SNetwork>().simpleNetworking.getWalletModule().sendToBankCardPreview(
          mainData!,
        );

    loader.finishLoadingImmediately();

    if (!response.hasError) {
      await sRouter.push(
        SendGloballyConfirmRouter(
          data: response.data!,
          method: method!,
        ),
      );
    } else {
      sNotification.showError(
        response.error?.cause ?? intl.something_went_wrong,
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
      accuracy: sendCurrency!.accuracy,
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
        assetSymbol: sendCurrency!.symbol,
        assetBalance: Decimal.parse(withAmount),
      );

      baseConversionValue = truncateZerosFrom(baseValue.toString());
    } else {
      baseConversionValue = zero;
    }
  }

  @action
  void _validateAmount() {
    final error = onGloballyWithdrawInputErrorHandler(withAmount, sendCurrency!, null);

    final value = Decimal.parse(withAmount);

    if (minLimitAmount > value) {
      limitError = '${intl.currencyBuy_paymentInputErrorText1} ${volumeFormat(
        decimal: minLimitAmount,
        accuracy: sendCurrency!.accuracy,
        symbol: sendCurrency!.symbol,
      )}';
    } else if (maxLimitAmount < value) {
      limitError = '${intl.currencyBuy_paymentInputErrorText2} ${volumeFormat(
        decimal: maxLimitAmount,
        accuracy: sendCurrency!.accuracy,
        symbol: sendCurrency!.symbol,
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

    if (withAmmountInputError != InputError.none) {
      sAnalytics.globalSendErrorLimit(
        errorCode: withAmmountInputError == InputError.limitError ? limitError : withAmmountInputError.name,
        asset: sendCurrency!.symbol,
        sendMethodType: '1',
        destCountry: countryCode,
        paymentMethod: method?.name ?? '',
        globalSendType: method?.methodId ?? '',
      );
    }
    withValid = error == InputError.none && isInputValid(withAmount);
  }
}
