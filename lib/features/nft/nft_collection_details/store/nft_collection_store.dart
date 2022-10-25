import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_modules.dart';
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
  NftModel? nftModel;

  @observable
  ObservableList<NFTCollectionFilter> filterValues = ObservableList.of([]);

  @observable
  ObservableList<NFTCollectionFilter> selectedFilter = ObservableList.of([]);

  ///

  @observable
  ObservableList<NftMarket> availableNFT = ObservableList.of([]);

  @observable
  ObservableList<NftMarket> availableNFTFiltred = ObservableList.of([]);

  @observable
  NFTCollectionFilter? availableFilter;

  @observable
  bool isAvailableHide = false;
  @action
  void setSsAvailableHide() => isAvailableHide = !isAvailableHide;

  ///

  @observable
  ObservableList<NftMarket> soldNFT = ObservableList.of([]);

  @observable
  ObservableList<NftMarket> soldNFTFiltred = ObservableList.of([]);

  @observable
  NFTCollectionFilter? soldFilter;

  @observable
  bool isSoldHide = false;
  @action
  void setIsSoldHide() => isSoldHide = !isSoldHide;

  @action
  void init(String collectionID) {
    nftModel = sSignalRModules.nftList
        .where((element) => element.id == collectionID)
        .first;

    filterValues = ObservableList.of([
      NFTCollectionFilter.priceLowToHigh,
      NFTCollectionFilter.priceHighToLow,
      NFTCollectionFilter.recentlyAdded,
      NFTCollectionFilter.oldest,
      NFTCollectionFilter.mostRare,
      NFTCollectionFilter.leastRare,
    ]);

    var avNFTList = nftModel!.nftList
        .where((e) => e.clientId == null && e.sellPrice != null)
        .toList();

    var soldNFTList =
        nftModel!.nftList.where((e) => e.sellPrice == null).toList();

    availableNFT = ObservableList.of(avNFTList);
    availableNFTFiltred = ObservableList.of(avNFTList);

    soldNFT = ObservableList.of(soldNFTList);
    soldNFTFiltred = ObservableList.of(soldNFTList);
  }

  @action
  void activeFilter(NFTCollectionFilter filter, bool isAvailableNFT) {
    if (isAvailableNFT) {
      availableFilter = filter;

      availableNFTFiltred = ObservableList.of(
        filterList(
          filter,
          availableNFTFiltred,
          isAvailableNFT,
        ),
      );
    } else {
      soldFilter = filter;

      soldNFTFiltred = ObservableList.of(
        filterList(
          filter,
          soldNFTFiltred,
          isAvailableNFT,
        ),
      );
    }
  }

  List<NftMarket> filterList(
    NFTCollectionFilter filter,
    List<NftMarket> list,
    bool isAvailableNFT,
  ) {
    var l = list.toList();

    switch (filter) {
      case NFTCollectionFilter.priceLowToHigh:
        if (isAvailableNFT) {
          l.sort((a, b) => a.sellPrice!.compareTo(b.sellPrice!));
        } else {
          l.sort((a, b) => a.buyPrice!.compareTo(b.buyPrice!));
        }
        break;

      case NFTCollectionFilter.priceHighToLow:
        if (isAvailableNFT) {
          l.sort((a, b) => a.sellPrice!.compareTo(b.sellPrice!));
        } else {
          l.sort((a, b) => a.buyPrice!.compareTo(b.buyPrice!));
        }
        break;

      case NFTCollectionFilter.recentlyAdded:
        l.sort((a, b) => b.mintDate!.compareTo(a.mintDate!));
        break;

      case NFTCollectionFilter.oldest:
        l.sort((a, b) => a.mintDate!.compareTo(b.mintDate!));
        break;

      case NFTCollectionFilter.mostRare:
        l.sort((a, b) => b.rarityId!.compareTo(a.rarityId!));
        break;

      case NFTCollectionFilter.leastRare:
        l.sort((a, b) => a.rarityId!.compareTo(b.rarityId!));
        break;
      default:
    }

    print(l);

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
