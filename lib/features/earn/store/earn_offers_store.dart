import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/signal_r/models/earn_offers_model.dart';

part 'earn_offers_store.g.dart';

class EarnOffersStore extends _EarnOffersStoreBase with _$EarnOffersStore {
  EarnOffersStore() : super();

  static _EarnOffersStoreBase of(BuildContext context) =>
      Provider.of<EarnOffersStore>(context, listen: false);
}

abstract class _EarnOffersStoreBase with Store {
  _EarnOffersStoreBase();

  @computed
  List<EarnOfferModel> get earnOffers => sSignalRModules.earnOffersList;

  @computed
  List<EarnOfferModel> get earnOffersFiltred {
    final localList = earnOffers.toList();

    localList.sort((a, b) => a.currentApy.compareTo(b.currentApy));

    return localList.toList();
  }

  @observable
  bool useAnotherItem = false;
  @action
  bool setUseAnotherItem(bool value) => useAnotherItem = value;

  @action
  bool isActiveState(List<EarnOfferModel> array) {
    var isActive = false;
    for (final element in array) {
      if (element.amount > Decimal.zero) {
        isActive = true;
      }
    }

    return isActive;
  }

  @action
  int getActiveLength(List<EarnOfferModel> array) {
    return array.map((e) => e.amount > Decimal.zero).toList().length;
  }
}
