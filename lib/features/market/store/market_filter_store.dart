import 'package:flutter/material.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/models/nft_model.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

part 'market_filter_store.g.dart';

class MarketFilterStore extends _MarketFilterStoreBase
    with _$MarketFilterStore {
  MarketFilterStore() : super();

  static _MarketFilterStoreBase of(BuildContext context) =>
      Provider.of<MarketFilterStore>(context, listen: false);
}

abstract class _MarketFilterStoreBase with Store {
  static final _logger = Logger('MarketFilterStore');

  @observable
  ObservableList<MarketItemModel> cryptoList = ObservableList.of([]);

  @observable
  ObservableList<MarketItemModel> cryptoListFiltred = ObservableList.of([]);

  @observable
  ObservableList<NftModel> nftList = ObservableList.of([]);

  @observable
  ObservableList<NftModel> nftListFiltred = ObservableList.of([]);

  @observable
  ObservableList<NftCollectionCategoryEnum> nftFilterSelected =
      ObservableList.of([]);

  @action
  void init(List<MarketItemModel> crypto, List<NftModel> nft) {
    cryptoList = ObservableList.of(crypto);
    cryptoListFiltred = ObservableList.of(crypto);

    var nftSorted = nft.toList();

    nftSorted.sort((a, b) => b.order!.compareTo(a.order!));

    nftList = ObservableList.of(nftSorted);
    nftListFiltred = ObservableList.of(nftSorted);
    nftFilterSelected = ObservableList.of([]);
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

    filterDone();
  }

  @action
  void filterDone() {
    if (nftFilterSelected.isEmpty) {
      nftListFiltred = ObservableList.of(nftList);

      return;
    }

    final list = nftListFiltred
        .where((element) => nftFilterSelected.contains(element.category));

    nftListFiltred = ObservableList.of(list);
  }
}
