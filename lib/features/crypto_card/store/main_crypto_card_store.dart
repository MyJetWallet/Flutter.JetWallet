import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/sensitive_info_crypto_card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/sensitive_info_crypto_card_response_model.dart';

part 'main_crypto_card_store.g.dart';

class MainCryptoCardStore extends _MainCryptoCardStoreBase with _$MainCryptoCardStore {
  MainCryptoCardStore() : super();

  _MainCryptoCardStoreBase of(BuildContext context) => Provider.of<MainCryptoCardStore>(context);
}

abstract class _MainCryptoCardStoreBase with Store {
  @observable
  bool showAddToWalletBanner = false;

  @observable
  SensitiveInfoCryptoCardResponseModel? sensitiveInfo;

  @action
  Future<void> init() async {
    final bannerClosed = bool.tryParse(
          await sLocalStorageService.getValue(isCryptoCardAddToWalletBannerClosed) ?? 'false',
        ) ??
        false;
    showAddToWalletBanner = !bannerClosed;

    try {
      final cardId = sSignalRModules.cryptoCardProfile.cards.first.cardId;
      final model = SensitiveInfoCryptoCardRequestModel(cardId: cardId);

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
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'MainCryptoCardStore',
            message: 'init error: $error',
          );
    }
  }

  @action
  Future<void> closeBanner() async {
    showAddToWalletBanner = false;
    await sLocalStorageService.setString(isCryptoCardAddToWalletBannerClosed, 'true');
  }
}
