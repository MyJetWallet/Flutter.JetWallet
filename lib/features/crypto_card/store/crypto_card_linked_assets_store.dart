import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_ui_kit/flutter_ui_kit.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/change_asset_list_request_model.dart';

part 'crypto_card_linked_assets_store.g.dart';

const String _tag = 'CryptoCardlinkedAssetsStore';

class CryptoCardlinkedAssetsStore extends _CryptoCardlinkedAssetsStoreBase with _$CryptoCardlinkedAssetsStore {
  CryptoCardlinkedAssetsStore() : super();

  _CryptoCardlinkedAssetsStoreBase of(BuildContext context) => Provider.of<CryptoCardlinkedAssetsStore>(context);
}

abstract class _CryptoCardlinkedAssetsStoreBase with Store {
  @observable
  StackLoaderStore loader = StackLoaderStore();

  @observable
  ObservableList<String> _avaibleAssetsSymbols = ObservableList.of([]);

  @computed
  List<String> get _associateAssetList {
    return sSignalRModules.cryptoCardProfile.associateAssetList;
  }

  @computed
  CurrencyModel get selectedAsset => getIt<FormatService>().findCurrency(
        assetSymbol: _associateAssetList.firstOrNull ?? '',
      );

  @computed
  CurrencyModel get cardBaseAsset => getIt<FormatService>().findCurrency(
        assetSymbol: 'EUR',
      );

  @computed
  ObservableList<CurrencyModel> get avaibleAssets {
    final result = ObservableList<CurrencyModel>.of([]);
    for (final symbol in _avaibleAssetsSymbols) {
      final asset = getIt<FormatService>().findCurrency(
        assetSymbol: symbol,
      );
      result.add(asset);
    }

    return result;
  }

  @computed
  bool get showSearch => avaibleAssets.length > 7;

  @observable
  String searchValue = '';

  @computed
  ObservableList<CurrencyModel> get filterdAssets {
    final result = avaibleAssets.where((element) {
      return element.description.toLowerCase().contains(searchValue) ||
          element.symbol.toLowerCase().contains(searchValue);
    }).toList();

    result.sort((a, b) => a.weight.compareTo(b.weight));
    result.sort((a, b) => b.baseBalance.compareTo(a.baseBalance));

    if (result.any((asset) => asset.symbol == 'USDT')) {
      final usdtAsset = result.firstWhere((asset) => asset.symbol == 'USDT');
      result.removeWhere((asset) => asset.symbol == 'USDT');
      result.insert(0, usdtAsset);
    }

    return ObservableList.of(result);
  }

  @action
  Future<void> init() async {
    try {
      unawaited(getAssetListCryptoCard());
    } catch (error) {
      logError(
        message: 'init error: $error',
      );
    }
  }

  @action
  void onCahngeSearch(String value) {
    searchValue = value;
  }

  @action
  Future<void> onChooseAsset(CurrencyModel asset) async {
    try {
      loader.startLoadingImmediately();
      final cryptoCardProfile = sSignalRModules.cryptoCardProfile;
      final cryptoCard = cryptoCardProfile.cards.firstOrNull;
      final cardId = cryptoCard?.cardId;

      if (cardId == null) throw Exception();

      final model = ChangeAssetListRequestModel(
        cardId: cardId,
        assets: [asset.symbol],
      );

      final response = await sNetwork.getWalletModule().setAssetsCryptoCard(model);
      response.pick(
        onNoError: (data) {
          sNotification.showError(intl.crypto_card_unfreeze_toast, id: 1, isError: false);
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            id: 1,
          );
        },
      );
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        id: 1,
      );
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
      );
      logError(
        message: 'onChooseAsset error: $error',
      );
    } finally {
      loader.finishLoadingImmediately();
    }
  }

  @action
  Future<void> getAssetListCryptoCard() async {
    try {
      final response = await sNetwork.getWalletModule().getAssetListCryptoCard();

      response.pick(
        onData: (data) {
          _avaibleAssetsSymbols = ObservableList.of(data.assets);
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            id: 1,
          );
        },
      );
    } on ServerRejectException catch (error) {
      sNotification.showError(
        error.cause,
        id: 1,
      );
    } catch (error) {
      sNotification.showError(
        intl.something_went_wrong_try_again2,
        id: 1,
      );
      logError(
        message: 'getAssetListCryptoCard error: $error',
      );
    }
  }

  void logError({required String message}) {
    getIt.get<SimpleLoggerService>().log(
          level: Level.error,
          place: _tag,
          message: message,
        );
  }
}
