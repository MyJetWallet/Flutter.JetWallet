import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';

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
  ObservableList cardsMethods = ObservableList.of([]);
  @observable
  ObservableList localMethods = ObservableList.of([]);
  @observable
  ObservableList p2pMethods = ObservableList.of([]);

  @action
  void init(CurrencyModel asset, PaymentAsset currency) {
    asset.buyMethods.forEach((element) {
      log(element.toString());

      if (element.category == PaymentMethodCategory.cards) {
        cardsMethods.add(element);
      } else if (element.category == PaymentMethodCategory.local) {
        localMethods.add(element);
      } else if (element.category == PaymentMethodCategory.p2p) {
        p2pMethods.add(element);
      }
    });
  }

  @computed
  bool get showSearch => true; //globalSendMethods.length >= 7;

  @action
  void search(String value) {}
}
