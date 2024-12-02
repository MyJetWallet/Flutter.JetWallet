import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/change_lable_crypto_card_request_model.dart';

part 'crypto_card_name_store.g.dart';

const String _tag = 'CryptoCardNameStore';

class CryptoCardNameStore extends _CryptoCardNameStoreBase with _$CryptoCardNameStore {
  CryptoCardNameStore({required super.cardId}) : super();

  static _CryptoCardNameStoreBase of(BuildContext context) => Provider.of<CryptoCardNameStore>(context);
}

abstract class _CryptoCardNameStoreBase with Store {
  _CryptoCardNameStoreBase({required this.cardId});

  final String cardId;

  final TextEditingController controller = TextEditingController();

  final int nameMaxLength = 25;

  @observable
  StackLoaderStore loader = StackLoaderStore();

  @observable
  String? cardName;

  @computed
  bool get isNameValid {
    if (cardName == null) return false;

    return cardName!.isNotEmpty && cardName!.length <= nameMaxLength;
  }

  @action
  void setCryptoCardName(String? name) {
    cardName = name;
  }

  @action
  Future<void> changeCardName() async {
    try {
      loader.startLoadingImmediately();

      final model = ChangeLableCryptoCardRequestModel(
        cardId: cardId,
        label: cardName ?? '',
      );

      final response = await sNetwork.getWalletModule().changeLableCryptoCard(model);
      response.pick(
        onData: (data) {
          sRouter.popUntilRoot();
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
      logError(
        message: 'loadPrewiew error: $e',
      );
    } finally {
      loader.finishLoadingImmediately();
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
