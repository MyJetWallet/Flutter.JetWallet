import 'dart:async';

import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/crypto_card/create_crypto_card_request_model.dart';
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
  }) {
    toAssetSymbol = discount.assetSymbol;
    toAmount = discount.userPrice;

    fromAmount =
        discount.prices.firstWhereOrNull((asset) => asset.assetSymbol == fromAssetSymbol)?.userPrice ?? Decimal.zero;
  }

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
  bool isCheckBoxSelected = false;

  @computed
  Decimal get price {
    final amount = formatService.convertOneCurrencyToAnotherOne(
      fromCurrency: fromAssetSymbol,
      fromCurrencyAmmount: Decimal.one,
      toCurrency: toAssetSymbol,
      baseCurrency: sSignalRModules.baseCurrency.symbol,
      isMin: false,
    );
    return amount;
  }

  @computed
  bool get isContinueAvaible => isCheckBoxSelected;

  @action
  void toggleCheckBox() {
    isCheckBoxSelected = !isCheckBoxSelected;
  }

  @action
  Future<void> onContinueTap() async {
    try {
      loader.startLoadingImmediately();
      final model = CreateCryptoCardRequestModel(
        fromAsset: fromAssetSymbol,
        fromAssetVolume: fromAmount,
      );

      final response = await sNetwork.getWalletModule().createCryptoCard(model);

      response.pick(
        onData: (data) async {
          await showSuccessScreen(data.cardId);
        },
        onError: (error) {
          showFailureScreen(error.cause);
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

  Future<void> showSuccessScreen(String cardId) async {
    sAnalytics.viewSuccessScreen(
      paymentAsset: fromAssetSymbol,
      paymentAmountInCrypto: fromAmount.toString(),
    );
    await sRouter
        .push(
      SuccessScreenRouter(
        secondaryText: intl.crypto_card_confirmation_success_description,
      ),
    )
        .then(
      (value) {
        sRouter.push(
          CryptoCardNameRoute(cardId: cardId),
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

    sAnalytics.viewErrorScreen(
      paymentAsset: fromAssetSymbol,
      paymentAmountInCrypto: fromAmount.toString(),
      errorMessage: error,
      userAssetBalance: getIt<FormatService>()
          .findCurrency(
            assetSymbol: fromAssetSymbol,
          )
          .assetBalance
          .toString(),
    );

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
}
