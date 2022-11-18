import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/models/nft_model.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';

part 'market_filter_store.g.dart';

class MarketFilterStore extends _MarketFilterStoreBase
    with _$MarketFilterStore {
  MarketFilterStore() : super();

  static _MarketFilterStoreBase of(BuildContext context) =>
      Provider.of<MarketFilterStore>(context, listen: false);
}

abstract class _MarketFilterStoreBase with Store {
  static final _logger = Logger('MarketFilterStore');

  @computed
  List<NftModel> get nftList => sSignalRModules.nftList;

  @computed
  List<NftModel> get nftListFiltred {
    final localList = nftList.toList();
    localList.sort((a, b) => b.order!.compareTo(a.order!));

    if (nftFilterSelected.isEmpty) {
      return localList;
    }

    final list = localList
        .where((element) => nftFilterSelected.contains(element.category));

    return list.toList();
  }

  @observable
  ObservableList<NftCollectionCategoryEnum> nftFilterSelected =
      ObservableList.of([]);

  @computed
  List<MarketItemModel> get cryptoList => sSignalRModules.getMarketPrices;

  @computed
  List<MarketItemModel> get cryptoListFiltred {
    if (cryptoList.isEmpty) {
      sAnalytics.nftMarketOpen();
    }

    return cryptoList;
  }

  @action
  void nftFilterAction(NftCollectionCategoryEnum item) {
    if (nftFilterSelected.contains(item)) {
      nftFilterSelected.remove(item);
    } else {
      nftFilterSelected.add(item);
    }
  }

  @action
  void nftFilterReset() {
    nftFilterSelected = ObservableList.of([]);
  }
}
