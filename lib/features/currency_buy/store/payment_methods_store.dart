// ignore_for_file: avoid_bool_literals_in_conditional_expressions

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/key_value_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/currency_buy/helper/formatted_circle_card.dart';
import 'package:jetwallet/features/currency_buy/models/formatted_circle_card.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/currencies_helpers.dart';
import 'package:jetwallet/utils/helpers/is_card_expired.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/utils/models/base_currency_model/base_currency_model.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/signal_r/models/card_limits_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_remove/card_remove_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/delete_card/delete_card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/unlimint/delete_unlimint_card_request_model.dart';

part 'payment_methods_store.g.dart';

class PaymentMethodsScreenStore extends _PaymentMethodsStoreBase with _$PaymentMethodsScreenStore {
  PaymentMethodsScreenStore(super.currencyModel);

  static _PaymentMethodsStoreBase of(BuildContext context) =>
      Provider.of<PaymentMethodsScreenStore>(context, listen: false);
}

abstract class _PaymentMethodsStoreBase with Store {
  _PaymentMethodsStoreBase(this.currencyModel) {
    lastUsedPaymentMethod = sSignalRModules.keyValue.lastUsedPaymentMethod;

    _initCurrencies();
    _initBaseCurrency();
    _initCardLimit();
  }

  late final CurrencyModel currencyModel;
  late final String? lastUsedPaymentMethod;

  static final _logger = Logger('PaymentMethodsStore');

  @observable
  bool disableSubmit = false;
  @action
  bool setDisableSubmit(bool value) => disableSubmit = value;

  @observable
  bool editMode = false;

  @observable
  CardLimitsModel? cardLimit;

  @observable
  BaseCurrencyModel? baseCurrency;

  @observable
  CircleCard? pickedCircleCard;

  @observable
  CircleCard? pickedUnlimintCard;

  @observable
  CircleCard? pickedAltUnlimintCard;

  @observable
  FormattedCircleCard? selectedCircleCard;

  @observable
  BuyMethodDto? selectedPaymentMethod;

  @observable
  CurrencyModel? selectedCurrency;

  @observable
  String? paymentMethodInputError;

  @observable
  ObservableList<CurrencyModel> currencies = ObservableList.of([]);

  @observable
  ObservableList<CircleCard> circleCards = ObservableList.of([]);

  @computed
  List<CircleCard> get unlimintCards => sSignalRModules.cards.cardInfos
      .where(
        (element) => element.integration == IntegrationType.unlimint,
      )
      .toList();

  @computed
  List<CircleCard> get unlimintAltCards => sSignalRModules.cards.cardInfos
      .where(
        (element) => element.integration == IntegrationType.unlimintAlt,
      )
      .toList();

  @observable
  StackLoaderStore loader = StackLoaderStore();

  @action
  void _initCurrencies() {
    final tempCurrencies = ObservableList.of(sSignalRModules.currenciesList);

    sortCurrencies(tempCurrencies);
    removeEmptyCurrenciesFrom(tempCurrencies);
    removeCurrencyFrom(tempCurrencies, currencyModel);
    currencies = tempCurrencies;
  }

  @action
  void _initBaseCurrency() {
    baseCurrency = sSignalRModules.baseCurrency;
  }

  @action
  void _initCardLimit() {
    final tempCardLimit = sSignalRModules.cardLimitsModel;

    cardLimit = tempCardLimit;
  }

  @action
  Future<void> _fetchCircleCards() async {
    if (currencyModel.supportsCircle) {
      loader.startLoadingImmediately();

      try {
        final response = await sNetwork.getWalletModule().getAllCards();

        response.pick(
          onData: (data) {
            final dataCards = data.cards.toList();

            dataCards.removeWhere(
              (card) {
                return isCardExpired(card.expMonth, card.expYear) || card.status == CircleCardStatus.failed;
              },
            );

            if (dataCards.isNotEmpty) {
              circleCards = ObservableList.of(dataCards);
            }
          },
        );
      } finally {
        loader.finishLoadingImmediately();
      }
    }
  }

  @action
  Future<void> initDefaultPaymentMethod({required bool fromCard}) async {
    _logger.log(notifier, 'initDefaultPaymentMethod');

    await _fetchCircleCards();
  }

  @action
  void updateSelectedPaymentMethod(
    BuyMethodDto? method, {
    bool isLocalUse = false,
  }) {
    _logger.log(notifier, 'updateSelectedPaymentMethod');

    selectedCurrency = null;
    selectedPaymentMethod = method;
    pickedUnlimintCard = isLocalUse ? pickedUnlimintCard : null;
    pickedAltUnlimintCard = isLocalUse ? pickedAltUnlimintCard : null;
  }

  @action
  void updateSelectedCurrency(CurrencyModel? currency) {
    _logger.log(notifier, 'updateSelectedCurrency');

    selectedCurrency = currency;
    selectedPaymentMethod = null;
  }

  @action
  void updateSelectedCircleCard(CircleCard card) {
    _logger.log(notifier, 'updateSelectedCircleCard');

    final method = currencyModel.buyMethods.where((method) {
      return method.id == PaymentMethodType.circleCard;
    });

    pickedCircleCard = card;
    selectedCircleCard = formattedCircleCard(card, baseCurrency!);

    updateSelectedPaymentMethod(method.first);
  }

  @action
  void updateSelectedUnlimintCard(CircleCard card) {
    _logger.log(notifier, 'updateSelectedUnlimintCard');

    final method = currencyModel.buyMethods.where((method) {
      return method.id == PaymentMethodType.unlimintCard;
    });

    pickedUnlimintCard = card;

    updateSelectedPaymentMethod(method.first, isLocalUse: true);
  }

  @action
  void updateSelectedAltUnlimintCard(CircleCard card) {
    _logger.log(notifier, 'updateSelectedAltUnlimintCard');

    final method = currencyModel.buyMethods.where((method) {
      return method.id == PaymentMethodType.bankCard;
    });

    pickedAltUnlimintCard = card;
    updateSelectedPaymentMethod(method.first, isLocalUse: true);
  }

  @action
  Future<void> setLastUsedPaymentMethod() async {
    _logger.log(notifier, 'setLastUsedPaymentMethod');

    try {
      await getIt.get<KeyValuesService>().addToKeyValue(
            KeyValueRequestModel(
              keys: [
                KeyValueResponseModel(
                  key: lastUsedPaymentMethodKey,
                  value: jsonEncode('simplex'),
                ),
              ],
            ),
          );
    } catch (e) {
      _logger.log(stateFlow, 'setLastUsedPaymentMethod', e);
    }
  }

  @action
  Future<void> onCircleCardAdded(CircleCard card) async {
    _logger.log(notifier, 'onCircleCardAdded');

    await _fetchCircleCards();
    updateSelectedCircleCard(card);
  }

  @action
  void toggleEditMode() {
    editMode = !editMode;
  }

  @action
  Future<void> deleteCard(CircleCard card) async {
    _logger.log(notifier, 'deleteCard');

    try {
      if (card.integration == IntegrationType.circle || card.integration == null) {
        final model = DeleteCardRequestModel(cardId: card.id);
        final _ = await sNetwork.getWalletModule().postDeleteCard(model);
        Timer(const Duration(milliseconds: 1500), () {
          _fetchCircleCards();
        });
      } else if (card.integration == IntegrationType.unlimint) {
        final model = DeleteUnlimintCardRequestModel(cardId: card.id);
        final _ = await sNetwork.getWalletModule().postDeleteUnlimintCard(model);
      } else if (card.integration == IntegrationType.unlimintAlt) {
        final model = CardRemoveRequestModel(cardId: card.id);
        final _ = await sNetwork.getWalletModule().cardRemove(model);
      }
    } catch (e) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
      );
    }
  }
}
