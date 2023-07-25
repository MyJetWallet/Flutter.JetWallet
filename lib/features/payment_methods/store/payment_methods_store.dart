import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/key_value_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/payment_methods/models/payment_methods_union.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/config/constants.dart';
import 'package:simple_networking/modules/signal_r/models/cards_model.dart';
import 'package:simple_networking/modules/wallet_api/models/address_book/address_book_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_remove/card_remove_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/delete_card/delete_card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/unlimint/delete_unlimint_card_request_model.dart';

part 'payment_methods_store.g.dart';

class PaymentMethodsStore extends _PaymentMethodsStoreBase
    with _$PaymentMethodsStore {
  PaymentMethodsStore() : super();

  static _PaymentMethodsStoreBase of(BuildContext context) =>
      Provider.of<PaymentMethodsStore>(context, listen: false);
}

abstract class _PaymentMethodsStoreBase with Store {
  _PaymentMethodsStoreBase() {
    final kV = sSignalRModules.keyValue;

    cardModel = sSignalRModules.cards;
    cards = ObservableList.of(sSignalRModules.cards.cardInfos);

    cardsIds = ObservableList.of(kV.cards?.value ?? <String>[]);

    getCards();
  }

  static final _logger = Logger('PaymentMethodsStore');

  late CardsModel cardModel;

  @observable
  ObservableList<String> cardsIds = ObservableList.of([]);

  @observable
  ObservableList<CircleCard> cards = ObservableList.of([]);

  @observable
  ObservableList<AddressBookContactModel> addressBookContacts =
      ObservableList.of([]);

  @observable
  PaymentMethodsUnion union = const PaymentMethodsUnion.loading();

  @computed
  bool get isShowAccounts => sSignalRModules.currenciesList
      .where((element) => element.supportIbanSendWithdrawal)
      .isNotEmpty;

  @computed
  List<CircleCard> get userCards => sSignalRModules.cards.cardInfos;

  bool cardsLoaded = false;
  bool addressBookLoaded = false;

  @action
  Future<void> getCards() async {
    cardsLoaded = false;

    _logger.log(notifier, 'getCards');
    cards = ObservableList.of(sSignalRModules.cards.cardInfos);

    cardsLoaded = true;
  }

  @action
  Future<void> clearData() async {
    _updateUnion(const PaymentMethodsUnion.loading());

    await getCards();

    _updateUnion(const PaymentMethodsUnion.success());
  }

  @action
  Future<void> getAddressBook() async {
    addressBookLoaded = false;

    if (isShowAccounts) {
      final response = await sNetwork.getWalletModule().getAddressBook('');

      response.pick(
        onData: (data) {
          addressBookContacts = ObservableList.of(data.contacts ?? []);

          addressBookContacts.sort((a, b) {
            return b.weight!.compareTo(a.weight!);
          });

          addressBookLoaded = true;

          _updateUnion(const PaymentMethodsUnion.success());
        },
      );
    }

    addressBookLoaded = true;
    _updateUnion(const PaymentMethodsUnion.success());
  }

  @action
  void _updateUnion(PaymentMethodsUnion _union) {
    if (_union is Success) {
      if (cardsLoaded && addressBookLoaded) {
        union = _union;
      }
    } else {
      union = _union;
    }
  }

  @action
  Future<void> deleteCard(CircleCard card) async {
    _logger.log(notifier, 'deleteCard');

    try {
      if (card.integration == IntegrationType.circle ||
          card.integration == null) {
        final model = DeleteCardRequestModel(cardId: card.id);
        final _ = sNetwork.getWalletModule().postDeleteCard(model);
      } else if (card.integration == IntegrationType.unlimint) {
        final model = DeleteUnlimintCardRequestModel(cardId: card.id);
        final _ = sNetwork.getWalletModule().postDeleteUnlimintCard(model);
      } else if (card.integration == IntegrationType.unlimintAlt) {
        final model = CardRemoveRequestModel(cardId: card.id);
        final _ = sNetwork.getWalletModule().cardRemove(model);
      }

      _deleteCardFromCardsBy(card.id);
    } catch (e) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
      );
    }
  }

  @action
  void _deleteCardFromCardsBy(String id) {
    cards = ObservableList.of(cards.where((card) => card.id != id).toList());
  }

  @action
  Future<void> addCardToKeyValue(String cardId) async {
    _logger.log(notifier, 'addCard');

    try {
      final set = Set.of(cardsIds);
      set.add(cardId);

      await getIt.get<KeyValuesService>().addToKeyValue(
            KeyValueRequestModel(
              keys: [
                KeyValueResponseModel(
                  key: cardsKey,
                  value: jsonEncode(set.toList()),
                ),
              ],
            ),
          );
    } catch (e) {
      _logger.log(stateFlow, 'addCardToKeyValue', e);
    }
  }

  @action
  void showFailure() {
    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.previewBuyWithCircle_failure,
        secondaryText: intl.previewBuyWithCircle_failureDescription,
        primaryButtonName: intl.previewBuyWithCircle_failureAnotherCard,
        onPrimaryButtonTap: () {
          sRouter.navigate(
            AddCircleCardRouter(
              onCardAdded: (card) {
                sRouter.pop();
              },
            ),
          );
        },
        secondaryButtonName: intl.previewBuyWithCircle_failureCancel,
        onSecondaryButtonTap: () {
          sRouter.pop();
        },
      ),
    );
  }
}
