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
  ObservableList<BuyMethodDto> localMethods = ObservableList.of([]);
  @observable
  ObservableList<BuyMethodDto> p2pMethods = ObservableList.of([]);

  @action
  Future<void> init(CurrencyModel asset, PaymentAsset currency) async {
    selectedAssset = asset;
    selectedCurrency = currency;

    log(asset.buyMethods.toString());

    asset.buyMethods.forEach((element) {
      final isCurrExist = element.paymentAssets!
          .indexWhere((element) => element.asset == buyCurrency.symbol);

      if (element.category == PaymentMethodCategory.cards) {
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

    log(localMethods.toString());
  }

  @computed
  bool get showSearch => true; //globalSendMethods.length >= 7;

  @action
  void search(String value) {}
}
