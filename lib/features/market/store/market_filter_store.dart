import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/key_value_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/models/nft_model.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_response_model.dart';

import '../helper/market_gainers.dart';
import '../helper/market_losers.dart';

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
  String activeFilter = 'all';

  @computed
  List<NftModel> get nftList => sSignalRModules.nftList;

  @computed
  List<NftModel> get nftListFiltred {
    final localList = nftList.toList();
    localList.sort((a, b) => a.order!.compareTo(b.order!));

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
    if (activeFilter == 'gainers') {
      return getMarketGainers();
    } else if (activeFilter == 'losers') {
      return getMarketLosers();
    }

    if (watchList.isNotEmpty) {
      List<MarketItemModel> newList = [];
      List<MarketItemModel> localList = cryptoList.toList();

      for (var i = 0; i < watchListIds.length; i++) {
        final obj = cryptoList.indexWhere(
          (element) => element.associateAsset == watchListIds[i],
        );

        if (obj != -1) {
          newList.add(
            cryptoList[obj],
          );
          localList.remove(
            cryptoList[obj],
          );
        }
      }

      return newList + localList;
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

  @action
  void cryptoFilterChange(String newFilter) {
    activeFilter = newFilter;
  }

  @computed
  List<String> get watchList {
    if (watchListLocal == null) {
      watchListLocal = ObservableList.of(watchListIds);

      return watchListIds;
    }

    return watchListLocal ?? [];
  }

  @computed
  List<String> get watchListIds =>
      sSignalRModules.keyValue.watchlist?.value ?? [];

  @observable
  ObservableList<String>? watchListLocal;

  @action
  Future<void> removeFromWatchlist(String assetId) async {
    if (watchListLocal != null) watchListLocal!.remove(assetId);

    await getIt.get<KeyValuesService>().addToKeyValue(
          KeyValueRequestModel(
            keys: [
              KeyValueResponseModel(
                key: watchlistKey,
                value: jsonEncode(watchList),
              ),
            ],
          ),
        );
  }

  @action
  Future<void> addToWatchlist(String assetId) async {
    if (watchListLocal != null) watchListLocal!.add(assetId);

    await getIt.get<KeyValuesService>().addToKeyValue(
          KeyValueRequestModel(
            keys: [
              KeyValueResponseModel(
                key: watchlistKey,
                value: jsonEncode(watchList),
              ),
            ],
          ),
        );
  }
}
