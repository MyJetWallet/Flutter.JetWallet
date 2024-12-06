import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/limits_crypto_card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/limits_crypto_card_response_model.dart';

part 'crypto_card_limits_store.g.dart';

const String _tag = 'CryptoCardLimitsStore';

class CryptoCardLimitsStore extends _CryptoCardLimitsStoreBase with _$CryptoCardLimitsStore {
  CryptoCardLimitsStore({required super.cardId}) : super();

  static _CryptoCardLimitsStoreBase of(BuildContext context) => Provider.of<CryptoCardLimitsStore>(context);
}

abstract class _CryptoCardLimitsStoreBase with Store {
  _CryptoCardLimitsStoreBase({required this.cardId});

  final String cardId;

  @observable
  LimitsCryptoCardResponseModel? limits;

  @action
  Future<void> loadLimits() async {
    try {
      final model = LimitsCryptoCardRequestModel(cardId: cardId);

      final response = await sNetwork.getWalletModule().cryptoCardLimits(model);
      response.pick(
        onData: (data) {
          limits = data;
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
        message: 'loadLimits error: $error',
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
