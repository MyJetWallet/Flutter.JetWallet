import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/format_service.dart';
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

  @observable
  CurrencyModel? selectedAssset;
  @observable
  PaymentAsset? selectedCurrency;

  @observable
  bool cardSupportForThisAsset = false;

  @computed
  CurrencyModel get buyCurrency => getIt.get<FormatService>().findCurrency(
        findInHideTerminalList: true,
        assetSymbol: selectedCurrency?.asset ?? 'BTC',
      );

  @computed
  List<CircleCard> get unlimintAltCards => sSignalRModules.cards.cardInfos
      .where(
        (element) =>
            element.integration == IntegrationType.unlimintAlt &&
            element.cardAssetSymbol == selectedCurrency!.asset,
      )
      .toList();

  @observable
  ObservableList<BuyMethodDto> cardsMethods = ObservableList.of([]);
  @observable
  ObservableList<CircleCard> cardsMethodsFiltred = ObservableList.of([]);

  @observable
  ObservableList<BuyMethodDto> localMethods = ObservableList.of([]);
  @observable
  ObservableList<BuyMethodDto> localMethodsFilted = ObservableList.of([]);

  @observable
  ObservableList<BuyMethodDto> p2pMethods = ObservableList.of([]);
  @observable
  ObservableList<BuyMethodDto> p2pMethodsFiltred = ObservableList.of([]);

  @observable
  ObservableList<PaymentMethodSearchModel> searchList = ObservableList.of([]);

  @action
  Future<void> init(CurrencyModel asset, PaymentAsset currency) async {
    selectedAssset = asset;
    selectedCurrency = currency;

    asset.buyMethods.forEach((element) {
      final isCurrExist = element.paymentAssets!.indexWhere(
        (element) => element.asset == buyCurrency.symbol,
      );

      if (element.category == PaymentMethodCategory.cards) {
        cardSupportForThisAsset = true;
        if (isCurrExist != -1) {
          cardsMethods.add(element);
        }
      } else if (element.category == PaymentMethodCategory.local) {
        if (isCurrExist != -1) {
          localMethods.add(element);
        }
      } else if (element.category == PaymentMethodCategory.p2p) {
        if (isCurrExist != -1) {
          p2pMethods.add(element);
        }
      }
    });

    cardsMethodsFiltred = ObservableList.of(unlimintAltCards.toList());
    localMethodsFilted = ObservableList.of(localMethods.toList());
    p2pMethodsFiltred = ObservableList.of(p2pMethods.toList());
  }

  @computed
  bool get showSearch =>
      (cardsMethods.length + localMethods.length + p2pMethods.length) >= 7;

  @action
  void search(String value) {
    if (value.isEmpty) {
      searchList.clear();
    } else {
      searchList.clear();

      var cardF = cardsMethodsFiltred
          .where((element) => element.cardLabel?.contains(value) ?? false)
          .toList();
      var localF = localMethodsFilted
          .where((element) => element.id.name?.contains(value) ?? false)
          .toList();
      var p2pF = p2pMethodsFiltred
          .where((element) => element.id.name?.contains(value) ?? false)
          .toList();

      searchList.addAll(cardF
          .map((e) => PaymentMethodSearchModel(0, e.cardLabel ?? '', null, e))
          .toList());
      searchList.addAll(localF
          .map((e) => PaymentMethodSearchModel(1, e.id.name ?? '', e, null))
          .toList());
      searchList.addAll(p2pF
          .map((e) => PaymentMethodSearchModel(1, e.id.name ?? '', e, null))
          .toList());

      searchList.sort((a, b) => a.name.compareTo(b.name));
    }
  }
}

class PaymentMethodSearchModel {
  PaymentMethodSearchModel(this.type, this.name, this.method, this.card);

  int type = 0; // 0 - Card, 1 - AltMethod,
  String name = ''; // Sort by this parametr;
  BuyMethodDto? method;
  CircleCard? card;
}
