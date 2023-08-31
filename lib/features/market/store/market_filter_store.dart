import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/key_value_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/features/market/model/market_item_model.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/models/nft_model.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:quiver/collection.dart';
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
  _MarketFilterStoreBase() {
    reaction(
      (_) => watchListIds,
      (msg) => syncWatchListLocal(msg as List<String>),
    );

    watchListLocal = ObservableList.of(watchListIds);
  }

  final _logger = getIt.get<SimpleLoggerService>();
  final _loggerValue = 'MarketFilterStore';

  @observable
  String activeFilter = 'all';

  @observable
  bool isReordable = false;
  @action
  bool setIsReordable(bool value) => isReordable = value;

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
    if (activeFilter == 'gainers') {
      return getMarketGainers();
    } else if (activeFilter == 'losers') {
      return getMarketLosers();
    } else {
      return cryptoList;
    }
  }

  @computed
  List<MarketItemModel> get cryptoFiltred {
    final localCryptoList = cryptoListFiltred.toList();

    if (watchListLocal.isNotEmpty) {
      for (var i = 0; i < watchListIds.length; i++) {
        final obj = localCryptoList.indexWhere(
          (element) => element.associateAsset == watchListIds[i],
        );

        if (obj != -1) {
          localCryptoList.remove(
            localCryptoList[obj],
          );
        }
      }
    }

    return localCryptoList;
  }

  @computed
  List<MarketItemModel> get watchListFiltred {
    final output = <MarketItemModel>[];

    for (var i = 0; i < watchListLocal.length; i++) {
      final obj = cryptoListFiltred
          .indexWhere((element) => element.symbol == watchListLocal[i]);
      if (obj != -1) {
        output.add(cryptoListFiltred[obj]);
      }
    }

    return output;
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
  List<String> get watchListIds =>
      sSignalRModules.keyValue.watchlist?.value ?? [];

  @observable
  ObservableList<String> watchListLocal = ObservableList.of([]);
  @action
  void syncWatchListLocal(List<String> newList, {bool needUpdate = false}) {
    if (!compareLists(newList.toList(), watchListLocal.toList())) {
      watchListLocal = ObservableList.of(newList);
      if (needUpdate) {
        saveWatchlist();
      }

      _logger.log(
        level: Level.info,
        place: _loggerValue,
        message: 'syncWatchListLocal: $watchListLocal',
      );
    }
  }

  bool compareLists(List<String> a, List<String> b) {
    return listsEqual(a, b);
  }

  @action
  Future<void> removeFromWatchlist(String assetId) async {
    watchListLocal.remove(assetId);

    await saveWatchlist();
  }

  @action
  Future<void> addToWatchlist(String assetId) async {
    watchListLocal.add(assetId);

    await saveWatchlist();
  }

  @action
  Future<void> saveWatchlist() async {
    await getIt.get<KeyValuesService>().addToKeyValue(
          KeyValueRequestModel(
            keys: [
              KeyValueResponseModel(
                key: watchlistKey,
                value: jsonEncode(watchListLocal),
              ),
            ],
          ),
        );
  }
}
