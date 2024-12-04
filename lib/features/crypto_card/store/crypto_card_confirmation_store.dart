import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/crypto_card_message_model.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/create_crypto_card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/preview_crypto_card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/price_crypto_card_response_model.dart';

part 'crypto_card_confirmation_store.g.dart';

const String _tag = 'CryptoCardConfirmationStore';

class CryptoCardConfirmationStore extends _CryptoCardConfirmationStoreBase with _$CryptoCardConfirmationStore {
  CryptoCardConfirmationStore({
    required super.fromAssetSymbol,
    required super.discount,
  }) : super();

  static _CryptoCardConfirmationStoreBase of(BuildContext context) => Provider.of<CryptoCardConfirmationStore>(context);
}

abstract class _CryptoCardConfirmationStoreBase with Store {
  _CryptoCardConfirmationStoreBase({
    required this.fromAssetSymbol,
    required this.discount,
  });

  final formatService = getIt.get<FormatService>();

  @observable
  String fromAssetSymbol = '';

  final PriceCryptoCardResponseModel discount;

  @observable
  String toAssetSymbol = 'EUR';

  @computed
  CurrencyModel get fromAsset => formatService.findCurrency(
        assetSymbol: fromAssetSymbol,
      );

  @computed
  CurrencyModel get toAsset => formatService.findCurrency(
        assetSymbol: toAssetSymbol,
      );

  @observable
  Decimal fromAmount = Decimal.zero;

  @observable
  Decimal toAmount = Decimal.zero;

  @observable
  StackLoaderStore loader = StackLoaderStore();

  @observable
  bool isPreviewLoaded = false;

  @observable
  bool isCheckBoxSelected = false;

  String operationId = '';

  Decimal price = Decimal.zero;

  @computed
  bool get isContinueAvaible => isPreviewLoaded && isCheckBoxSelected;

  @action
  Future<void> loadPrewiev() async {
    try {
      loader.startLoadingImmediately();

      final model = PreviewCryptoCardRequestModel(
        fromAsset: fromAssetSymbol,
      );

      final response = await sNetwork.getWalletModule().cryptoCardPrewiev(model);
      response.pick(
        onData: (data) {
          operationId = data.operationId;
          toAssetSymbol = data.toAsset;
          toAmount = data.toAssetVolume;
          fromAssetSymbol = data.fromAsset;
          fromAmount = data.fromAssetVolume;
          price = data.price;

          isPreviewLoaded = true;
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

  @action
  void toggleCheckBox() {
    isCheckBoxSelected = !isCheckBoxSelected;
  }

  @action
  Future<void> onContinueTap() async {
    try {
      loader.startLoadingImmediately();
      final model = CreateCryptoCardRequestModel(
        operationId: operationId,
        price: price,
        fromAsset: fromAssetSymbol,
        fromAssetVolume: fromAmount,
      );

      final response = await sNetwork.getWalletModule().createCryptoCard(model);

      response.pick(
        onData: (data) async {
          changeLocalState();
          await showSuccessScreen();
        },
        onError: (error) {
          // TODO (Yaroslav): uncoment this when back fix responce
          //  showFailureScreen(error.cause);
          changeLocalState();
          showSuccessScreen();
        },
      );
    } on ServerRejectException catch (error) {
      await showFailureScreen(error.cause);
    } catch (error) {
      await showFailureScreen(intl.something_went_wrong_try_again2);
      logError(
        message: 'onContinueTap error: $error',
      );
    }
  }

  Future<void> showSuccessScreen() async {
    await sRouter
        .push(
      SuccessScreenRouter(
        secondaryText: intl.crypto_card_confirmation_success_description,
      ),
    )
        .then(
      (value) {
        // TODO (Yaroslav): add card id
        sRouter.push(
          CryptoCardNameRoute(cardId: ''),
        );
      },
    );
  }

  @action
  Future<void> showFailureScreen(String error) async {
    loader.finishLoadingImmediately();

    if (sRouter.currentPath != '/crypto_card_confirmation') {
      return;
    }

    unawaited(
      sRouter.push(
        FailureScreenRouter(
          primaryText: intl.previewBuyWithAsset_failure,
          secondaryText: error,
          onPrimaryButtonTap: () {},
        ),
      ),
    );
  }

  void logError({required String message}) {
    getIt.get<SimpleLoggerService>().log(
          level: Level.error,
          place: _tag,
          message: message,
        );
  }

  // TODO (Yaroslav): remove this function
  void changeLocalState() {
    sSignalRModules.cryptoCardProfile = const CryptoCardProfile(
      associateAssetList: ['USDT'],
      cards: [
        CryptoCardModel(
          cardId: 'mock',
          label: 'lable',
          last4: '5555',
          status: CryptoCardStatus.inCreation,
        ),
      ],
    );

    unawaited(
      Future.delayed(
        const Duration(seconds: 10),
        () {
          sSignalRModules.cryptoCardProfile = const CryptoCardProfile(
            associateAssetList: ['USDT'],
            cards: [
              CryptoCardModel(
                cardId: 'mock',
                label: 'lable',
                last4: '5555',
                status: CryptoCardStatus.active,
              ),
            ],
          );
        },
      ),
    );
  }
}
