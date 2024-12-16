import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/global_loader.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/crypto_card_message_model.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/freeze_crypto_card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/sensitive_info_crypto_card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/sensitive_info_crypto_card_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/unfreeze_crypto_card_request_model.dart';

part 'main_crypto_card_store.g.dart';

const String _tag = 'MainCryptoCardStore';

class MainCryptoCardStore extends _MainCryptoCardStoreBase with _$MainCryptoCardStore {
  MainCryptoCardStore() : super();

  _MainCryptoCardStoreBase of(BuildContext context) => Provider.of<MainCryptoCardStore>(context);
}

abstract class _MainCryptoCardStoreBase with Store {
  final globalLoader = getIt.get<GlobalLoader>();

  @computed
  CryptoCardModel get cryptoCard => sSignalRModules.cryptoCardProfile.cards.first;

  @computed
  List<String> get _linkedAssetSymbols {
    return sSignalRModules.cryptoCardProfile.associateAssetList;
  }

  @computed
  List<CurrencyModel> get linkedAssets {
    final result = <CurrencyModel>[];
    for (final symbol in _linkedAssetSymbols) {
      final asset = getIt<FormatService>().findCurrency(
        assetSymbol: symbol,
      );
      result.add(asset);
    }

    return result;
  }

  @computed
  Decimal get cardBalance {
    var result = Decimal.zero;

    for (final asset in linkedAssets) {
      final formatService = getIt.get<FormatService>();
      final availableBalance = formatService.convertOneCurrencyToAnotherOne(
        fromCurrency: asset.symbol,
        fromCurrencyAmmount: asset.assetBalance,
        toCurrency: cardBaseAsset.symbol,
        baseCurrency: sSignalRModules.baseCurrency.symbol,
        isMin: false,
      );
      result += availableBalance;
    }

    return result;
  }

  @computed
  CurrencyModel get cardBaseAsset {
    return currencyFrom(
      sSignalRModules.currenciesList,
      'EUR',
    );
  }

  @observable
  bool showAddToWalletBanner = false;

  @observable
  SensitiveInfoCryptoCardResponseModel? sensitiveInfo;

  @computed
  String get cardLast4 => cryptoCard.last4;

  @action
  Future<void> init() async {
    try {
      ///
      /// getSensitiveInfo
      ///
      if (cryptoCard.status == CryptoCardStatus.active) {
        unawaited(getSensitiveInfo());
      }

      ///
      /// Load banner state
      ///
      final bannerClosed = bool.tryParse(
            await sLocalStorageService.getValue(isCryptoCardAddToWalletBannerClosed) ?? 'false',
          ) ??
          false;
      showAddToWalletBanner = !bannerClosed;
    } catch (error) {
      logError(
        message: 'init error: $error',
      );
    }
  }

  @action
  Future<void> getSensitiveInfo() async {
    try {
      final model = SensitiveInfoCryptoCardRequestModel(cardId: cryptoCard.cardId);

      final response = await sNetwork.getWalletModule().sensitiveInfoCryptoCard(model);

      response.pick(
        onData: (data) {
          sensitiveInfo = data;
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
        message: 'getSensitiveInfo error: $error',
      );
    }
  }

  @action
  Future<void> freezeCard() async {
    globalLoader.setLoading(true);
    try {
      final model = FreezeCryptoCardRequestModel(cardId: cryptoCard.cardId);

      final response = await sNetwork.getWalletModule().freezeCard(model);

      response.pick(
        onNoError: (_) {
          sSignalRModules.localSetCryptoCardStatus(
            cardId: cryptoCard.cardId,
            status: CryptoCardStatus.frozen,
          );
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            id: 1,
          );
        },
      );

      sNotification.showError(intl.crypto_card_freeze_toast, id: 1, isError: false);
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
        message: 'freezeCard error: $error',
      );
    }
    globalLoader.setLoading(false);
  }

  @action
  Future<void> unfreezeCard() async {
    globalLoader.setLoading(true);
    try {
      final model = UnfreezeCryptoCardRequestModel(cardId: cryptoCard.cardId);

      final response = await sNetwork.getWalletModule().unfreezeCard(model);

      response.pick(
        onNoError: (_) {
          sSignalRModules.localSetCryptoCardStatus(
            cardId: cryptoCard.cardId,
            status: CryptoCardStatus.active,
          );
          getSensitiveInfo();
        },
        onError: (error) {
          sNotification.showError(
            error.cause,
            id: 1,
          );
        },
      );

      sNotification.showError(intl.crypto_card_unfreeze_toast, id: 1, isError: false);
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
        message: 'unfreezeCard error: $error',
      );
    }
    globalLoader.setLoading(false);
  }

  @action
  Future<void> closeBanner() async {
    showAddToWalletBanner = false;
    await sLocalStorageService.setString(isCryptoCardAddToWalletBannerClosed, 'true');
  }

  @action
  Future<void> deleteCard() async {
    try {
      globalLoader.setLoading(true);

      // TODO (Yaroslav): Replace with a real network request
      await Future.delayed(const Duration(seconds: 1));
      sSignalRModules.localDeleteCryptoCard(cryptoCard.cardId);

      sNotification.showError(
        intl.crypto_card_delete_terminated_toast(cardLast4),
        id: 1,
        isError: false,
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
        message: 'delete card error: $error',
      );
    } finally {
      globalLoader.setLoading(false);
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
