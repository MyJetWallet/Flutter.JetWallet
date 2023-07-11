import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/helpers/is_card_expired.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

part 'payment_method_store.g.dart';

class PaymentMethodStore extends _PaymentMethodStoreBase
    with _$PaymentMethodStore {
  PaymentMethodStore() : super();

  static PaymentMethodStore of(BuildContext context) =>
      Provider.of<PaymentMethodStore>(context, listen: false);
}

abstract class _PaymentMethodStoreBase with Store {
  TextEditingController searchController = TextEditingController();

  CurrencyModel? selectedAssset;

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
  ObservableList<BuyMethodDto> cardsMethods = ObservableList.of([]);
  @observable
  ObservableList<BuyMethodDto> localMethods = ObservableList.of([]);
  @observable
  ObservableList<BuyMethodDto> p2pMethods = ObservableList.of([]);

  @action
  Future<void> init(CurrencyModel asset, PaymentAsset currency) async {
    selectedAssset = asset;

    asset.buyMethods.forEach((element) {
      if (element.category == PaymentMethodCategory.cards) {
        cardsMethods.add(element);
        /*if (data.cardNumber != null && data.cardNumber!.isNotEmpty) {
          if (data.cardNumber![0] == '4') {
            cardNetwork = CircleCardNetwork.VISA;
          } else if (data.cardNumber![0] == '5') {
            cardNetwork = CircleCardNetwork.MASTERCARD;
          }
        }
        */
      } else if (element.category == PaymentMethodCategory.local) {
        localMethods.add(element);
      } else if (element.category == PaymentMethodCategory.p2p) {
        p2pMethods.add(element);
      }
    });

    // Placeholder for show add card in UI
    cardsMethods.add(
      const BuyMethodDto(
        id: PaymentMethodType.unsupported,
        category: PaymentMethodCategory.cards,
        termsAccepted: true,
      ),
    );

    await _fetchCircleCards(asset);

    log(unlimintAltCards.toString());
  }

  @computed
  bool get showSearch => true; //globalSendMethods.length >= 7;

  @action
  void search(String value) {}

  @action
  Future<void> _fetchCircleCards(CurrencyModel asset) async {
    if (asset.supportsCircle) {
      final response = await sNetwork.getWalletModule().getAllCards();

      response.pick(
        onData: (data) {
          final dataCards = data.cards.toList();

          dataCards.removeWhere(
            (card) {
              return isCardExpired(card.expMonth, card.expYear) ||
                  card.status == CircleCardStatus.failed;
            },
          );

          if (dataCards.isNotEmpty) {
            circleCards = ObservableList.of(dataCards);
          }
        },
      );
    }
  }
}
