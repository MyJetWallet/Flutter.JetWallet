import 'package:flutter/material.dart';
import 'package:jetwallet/utils/models/nft_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/modules/signal_r/models/nft_market.dart';

part 'nft_collection_store.g.dart';

class NFTCollectionDetailStore extends _NFTCollectionDetailStoreBase
    with _$NFTCollectionDetailStore {
  NFTCollectionDetailStore() : super();

  static _NFTCollectionDetailStoreBase of(BuildContext context) =>
      Provider.of<NFTCollectionDetailStore>(context, listen: false);
}

abstract class _NFTCollectionDetailStoreBase with Store {
  @observable
  ObservableList<NFTCollectionFilter> filterValues = ObservableList.of([]);

  @observable
  ObservableList<NFTCollectionFilter> selectedFilter = ObservableList.of([]);

  ///

  @observable
  ObservableList<NftMarket> availableNFT = ObservableList.of([]);

  @observable
  ObservableList<NftMarket> availableNFTFiltred = ObservableList.of([]);

  ///

  @observable
  ObservableList<NftMarket> soldNFT = ObservableList.of([]);

  @observable
  ObservableList<NftMarket> soldNFTFiltred = ObservableList.of([]);

  @action
  void init(NftModel nft) {
    filterValues = ObservableList.of([
      NFTCollectionFilter.priceLowToHigh,
      NFTCollectionFilter.priceHighToLow,
      NFTCollectionFilter.recentlyAdded,
      NFTCollectionFilter.oldest,
      NFTCollectionFilter.mostRare,
      NFTCollectionFilter.leastRare,
    ]);

    var avNFTList = nft.nftList
        .where((e) => e.clientId == null && e.sellPrice != null)
        .toList();

    var soldNFTList = nft.nftList.where((e) => e.sellPrice == null).toList();

    availableNFT = ObservableList.of(avNFTList);
    availableNFTFiltred = ObservableList.of(avNFTList);

    soldNFT = ObservableList.of(soldNFTList);
    soldNFTFiltred = ObservableList.of(soldNFTList);
  }

  @action
  void activeFilter(NFTCollectionFilter filter, bool isAvailableNFT) {
    if (isAvailableNFT) {
      availableNFTFiltred = ObservableList.of(
        filterList(
          filter,
          availableNFTFiltred,
        ),
      );
    } else {
      soldNFTFiltred = ObservableList.of(
        filterList(
          filter,
          soldNFTFiltred,
        ),
      );
    }
  }

  List<NftMarket> filterList(NFTCollectionFilter filter, List<NftMarket> list) {
    var l = list.toList();

    switch (filter) {
      case NFTCollectionFilter.priceLowToHigh:
        l.sort((a, b) => a.sellPrice!.compareTo(b.sellPrice!));
        break;
      case NFTCollectionFilter.priceHighToLow:
        l.sort((a, b) => b.sellPrice!.compareTo(a.sellPrice!));
        break;
      case NFTCollectionFilter.recentlyAdded:
        l.sort();
        break;

      case NFTCollectionFilter.oldest:
        l.sort();
        break;

      case NFTCollectionFilter.mostRare:
        l.sort();
        break;
      case NFTCollectionFilter.leastRare:
        l.sort();
        break;
      default:
    }

    return l;
  }
}

enum NFTCollectionFilter {
  priceLowToHigh('Price low to high'),
  priceHighToLow('Price high to low'),
  recentlyAdded('Recently Added'),
  oldest('Oldest'),
  mostRare('Most rare'),
  leastRare('Least rare');

  final String value;
  const NFTCollectionFilter(this.value);

  @override
  String toString() => '';
}
