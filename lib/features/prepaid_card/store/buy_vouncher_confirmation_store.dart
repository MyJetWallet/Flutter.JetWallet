import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/features/phone_verification/utils/simple_number.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/buy_purchase_card_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/buy_purchase_card_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/prepaid_card/purchase_card_brand_list_response_model.dart';

part 'buy_vouncher_confirmation_store.g.dart';

bool voucherHasJustBeenPurchased = false;

class BuyVouncherConfirmationStore extends _BuyVouncherConfirmationStoreBase with _$BuyVouncherConfirmationStore {
  BuyVouncherConfirmationStore() : super();

  static BuyVouncherConfirmationStore of(BuildContext context) =>
      Provider.of<BuyVouncherConfirmationStore>(context, listen: false);
}

abstract class _BuyVouncherConfirmationStoreBase with Store {
  @observable
  StackLoaderStore loader = StackLoaderStore();

  @observable
  bool isDataLoaded = false;
  @observable
  bool terminateUpdates = false;
  @action
  void termiteUpdate() {
    terminateUpdates = true;
  }

  @observable
  Decimal amount = Decimal.zero;

  @observable
  PurchaseCardBrandDtoModel? brand;

  @observable
  SPhoneNumber? country;

  @observable
  int actualTimeInSecond = 30;

  @observable
  Decimal price = Decimal.zero;

  @observable
  bool isWaitingSkipped = false;
  @observable
  bool wasAction = false;

  @observable
  bool isBankTermsChecked = false;
  @observable
  bool firstBuy = false;
  @action
  void setIsBankTermsChecked() {
    isBankTermsChecked = !isBankTermsChecked;
  }

  @computed
  bool get getCheckbox => isBankTermsChecked;

  @observable
  bool showProcessing = false;

  @computed
  CurrencyModel get buyCurrency => sSignalRModules.currenciesWithHiddenList.firstWhere(
        (currency) => currency.symbol == (brand?.currency ?? 'USD'),
        orElse: () => CurrencyModel.empty(),
      );

  @computed
  CurrencyModel get payCurrency => sSignalRModules.currenciesWithHiddenList.firstWhere(
        (currency) => currency.symbol == 'USDT',
        orElse: () => CurrencyModel.empty(),
      );

  @computed
  CurrencyModel get depositFeeCurrency => sSignalRModules.currenciesWithHiddenList.firstWhere(
        (currency) => currency.symbol == (brand?.currency ?? 'USD'),
        orElse: () => CurrencyModel.empty(),
      );

  @observable
  BuyPurchaseCardResponseModel? prewievResponce;

  @action
  Future<void> loadPreview({
    required Decimal amount,
    required PurchaseCardBrandDtoModel brand,
    required SPhoneNumber country,
  }) async {
    isDataLoaded = false;

    loader.startLoadingImmediately();

    this.amount = amount;
    this.brand = brand;
    this.country = country;

    await _isChecked();

    await requestQuote();

    loader.finishLoadingImmediately();

    isDataLoaded = true;
  }

  @action
  Future<void> getActualData() async {
    if (terminateUpdates) return;

    try {
      final model = BuyPurchaseCardRequestModel(
        amount: amount,
        productId: brand?.productId ?? 0,
        country: country?.isoCode ?? '',
      );

      final response = await sNetwork.getWalletModule().postBuyPrepaidCardPreview(model);

      response.pick(
        onData: (data) {
          prewievResponce = data;
        },
        onError: (error) {
          loader.finishLoadingImmediately();

          _showFailureScreen(error.cause);
        },
      );
    } on ServerRejectException catch (error) {
      loader.finishLoadingImmediately();

      unawaited(_showFailureScreen(error.cause));
    } catch (error) {
      loader.finishLoadingImmediately();

      unawaited(_showFailureScreen(intl.prepaid_card_error));
    } finally {
      loader.finishLoadingImmediately();

      isDataLoaded = true;
    }
  }

  @action
  Future<void> _showFailureScreen(String error) async {
    loader.finishLoadingImmediately();

    if (sRouter.currentPath != '/buy_vouncher_confirmation') {
      return;
    }

    unawaited(
      sRouter.push(
        FailureScreenRouter(
          primaryText: intl.previewBuyWithAsset_failure,
          secondaryText: error,
        ),
      ),
    );
  }

  @action
  Future<void> requestQuote() async {
    if (terminateUpdates) return;

    try {
      price = await getConversionPrice(
            ConversionPriceInput(
              baseAssetSymbol: buyCurrency.symbol,
              quotedAssetSymbol: payCurrency.symbol,
            ),
          ) ??
          Decimal.zero;

      await getActualData();
    } on ServerRejectException catch (error) {
      await _showFailureScreen(error.cause);
    } catch (error) {
      await _showFailureScreen(error.toString());
    }
  }

  @action
  Future<void> createPayment() async {
    unawaited(_setIsChecked());

    await _requestPaymentAccaunt();
  }

  @action
  Future<void> _requestPaymentAccaunt() async {
    try {
      termiteUpdate();

      showProcessing = true;
      wasAction = true;

      loader.startLoadingImmediately();

      final model = BuyPurchaseCardRequestModel(
        amount: amount,
        productId: brand?.productId ?? 0,
        country: country?.isoCode ?? '',
      );

      final resp = await sNetwork.getWalletModule().postBuyPrepaidCardExecute(model);

      if (resp.hasError) {
        await _showFailureScreen(resp.error?.cause ?? '');

        return;
      }

      if (sRouter.currentPath != '/buy_vouncher_confirmation') {
        return;
      }

      if (isWaitingSkipped) {
        return;
      }
      voucherHasJustBeenPurchased = true;

      unawaited(_showSuccessScreen());

      skippedWaiting();
    } on ServerRejectException catch (error) {
      unawaited(_showFailureScreen(error.cause));
    } catch (error) {
      unawaited(_showFailureScreen(intl.prepaid_card_error));
    }
  }

  @action
  Future<void> _showSuccessScreen() {
    return sRouter.push(
      SuccessScreenRouter(
        secondaryText: intl.prepaid_card_success(
          getIt<AppStore>().isBalanceHide
              ? '**** ${payCurrency.symbol}'
              : amount.toFormatCount(
                  symbol: buyCurrency.symbol,
                  accuracy: buyCurrency.accuracy,
                ),
        ),
        onSuccess: (_) async {
          sRouter.popUntilRouteWithName(PrepaidCardServiceRouter.name);
        },
      ),
    );
  }

  @action
  void skippedWaiting() {
    isWaitingSkipped = true;
  }

  @action
  Future<void> _isChecked() async {
    try {
      final storage = sLocalStorageService;

      final status = await storage.getValue(checkedBankCard);
      if (status != null) {
        isBankTermsChecked = true;
      } else {
        firstBuy = true;
      }
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'BuyConfirmationStore',
            message: e.toString(),
          );
    }
  }

  @action
  Future<void> _setIsChecked() async {
    try {
      final storage = sLocalStorageService;

      await storage.setString(checkedBankCard, 'true');
      isBankTermsChecked = true;
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'BuyConfirmationStore',
            message: e.toString(),
          );
    }
  }
}
