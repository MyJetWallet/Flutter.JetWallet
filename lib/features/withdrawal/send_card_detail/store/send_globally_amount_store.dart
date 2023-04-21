import 'package:decimal/decimal.dart';
import 'package:device_marketing_names/device_marketing_names.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/helpers/calculate_base_balance.dart';
import 'package:jetwallet/utils/helpers/input_helpers.dart';
import 'package:jetwallet/utils/helpers/string_helper.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:jetwallet/utils/models/selected_percent.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/send_globally/send_to_bank_request_model.dart';

part 'send_globally_amount_store.g.dart';

class SendGloballyAmountStore extends _SendGloballyAmountStoreBase
    with _$SendGloballyAmountStore {
  SendGloballyAmountStore() : super();

  static SendGloballyAmountStore of(BuildContext context) =>
      Provider.of<SendGloballyAmountStore>(context, listen: false);
}

abstract class _SendGloballyAmountStoreBase with Store {
  @observable
  SKeyboardPreset? selectedPreset;
  @observable
  String? tappedPreset;
  @action
  void tapPreset(String preset) => tappedPreset = preset;

  @observable
  String cardNumber = '';
  @observable
  CircleCardNetwork cardNetwork = CircleCardNetwork.unsupported;
  @action
  void setCardNumber(String card) {
    cardNumber = card;

    if (cardNumber[0] == '4') {
      cardNetwork = CircleCardNetwork.VISA;
    } else if (cardNumber[0] == '5') {
      cardNetwork = CircleCardNetwork.MASTERCARD;
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

  StackLoaderStore loader = StackLoaderStore();

  CurrencyModel eurCurrency = currencyFrom(
    sSignalRModules.currenciesList,
    'EUR',
  );

  @action
  Future<void> loadPreview() async {
    loader.startLoadingImmediately();

    final model = SendToBankRequestModel(
      countryCode: 'UA',
      cardNumber: cardNumber,
      asset: 'EUR',
      amount: Decimal.parse(withAmount),
    );

    final response = await getIt
        .get<SNetwork>()
        .simpleNetworking
        .getWalletModule()
        .sendToBankCardPreview(
          model,
        );

    loader.finishLoadingImmediately();

    if (!response.hasError) {
      print(response.data);

      await sRouter.push(
        SendGloballyConfirmRouter(
          data: response.data!,
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
    );

    withAmmountInputError =
        double.parse(withAmount) != 0 ? error : InputError.none;

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
