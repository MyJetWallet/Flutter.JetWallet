import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/price_crypto_card_response_model.dart';

part 'crypto_card_pay_asset_store.g.dart';

class CryptoCardPayAssetStore extends _CryptoCardPayAssetStoreBase with _$CryptoCardPayAssetStore {
  CryptoCardPayAssetStore() : super();

  static _CryptoCardPayAssetStoreBase of(BuildContext context) => Provider.of<CryptoCardPayAssetStore>(context);
}

abstract class _CryptoCardPayAssetStoreBase with Store {
  @observable
  StackLoaderStore loader = StackLoaderStore();

  @observable
  PriceCryptoCardResponseModel? price;

  @observable
  ObservableList<String> _avaibleAssetsSymbols = ObservableList.of([]);

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

  @observable
  CurrencyModel? selectedAsset;

  @computed
  CurrencyModel get priceAsset => getIt<FormatService>().findCurrency(
        assetSymbol: price?.assetSymbol ?? 'EUR',
      );

  @computed
  bool get isPayValid => selectedAsset != null && isEnoughBalanceToPay;

  @computed
  bool get isEnoughBalanceToPay {
    if (selectedAsset == null) return false;

    final userPrice = price?.userPrice ?? Decimal.zero;
    final needToPay = userPrice * Decimal.parse('1.05');

    final formatService = getIt.get<FormatService>();
    final avaibleBalance = formatService.convertOneCurrencyToAnotherOne(
      fromCurrency: selectedAsset?.symbol ?? '',
      fromCurrencyAmmount: selectedAsset?.assetBalance ?? Decimal.zero,
      toCurrency: price?.assetSymbol ?? 'EUR',
      baseCurrency: sSignalRModules.baseCurrency.symbol,
      isMin: true,
    );

    return needToPay < avaibleBalance;
  }

  @action
  Future<void> init() async {
    unawaited(_getPrice());
    unawaited(_getAssetsListCryptoCard());
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
  void onCahngeSearch(String value) {
    searchValue = value;
  }

  @action
  Future<void> onChooseAsset(CurrencyModel asset) async {
    selectedAsset = asset;
  }

  @action
  Future<void> _getPrice({bool showLoader = false}) async {
    try {
      if (showLoader) {
        loader.startLoadingImmediately();
      }

      final response = await sNetwork.getWalletModule().getPriceCryptoCard();
      response.pick(
        onData: (data) {
          price = data;
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            id: 1,
          );
        },
      );
    } catch (e) {
      sNotification.showError(
        intl.something_went_wrong_try_again,
        id: 1,
      );
    } finally {
      if (showLoader) {
        loader.finishLoadingImmediately();
      }
    }
  }

  @action
  Future<void> _getAssetsListCryptoCard({bool showLoader = false}) async {
    try {
      if (showLoader) {
        loader.startLoadingImmediately();
      }
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
    } finally {
      if (showLoader) {
        loader.finishLoadingImmediately();
      }
    }
  }

  @action
  void onContinueTap() {
    if (isPayValid) {
      sRouter.push(
        CryptoCardConfirmationRoute(
          fromAssetSymbol: selectedAsset?.symbol ?? '',
          discount: price!,
        ),
      );
    }
  }
}
