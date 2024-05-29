import 'dart:async';

import 'package:data_channel/data_channel.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/utils/device_binding_required_flow/show_device_binding_required_flow.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/helpers/rate_up/show_rate_up_popup.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/sell/execute_crypto_sell_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/sell/get_crypto_sell_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/swap_execute_quote/execute_quote_request_model.dart';

part 'sell_confirmation_store.g.dart';

class SellConfirmationStore extends _SellConfirmationStoreBase with _$SellConfirmationStore {
  SellConfirmationStore() : super();

  static SellConfirmationStore of(BuildContext context) => Provider.of<SellConfirmationStore>(context, listen: false);
}

abstract class _SellConfirmationStoreBase with Store {
  @observable
  StackLoaderStore loader = StackLoaderStore();

  @observable
  bool isDataLoaded = false;
  @observable
  bool terminateUpdates = false;
  @action
  void termiteUpdate() {
    terminateUpdates = true;
    cancelTimer();
  }

  final cancelToken = CancelToken();
  void cancelAllRequest() {
    cancelToken.cancel('exit');

    getIt.get<SimpleLoggerService>().log(
          level: Level.info,
          place: 'Buy Confirmation Store',
          message: 'cancel REQUESTS',
        );
  }

  @observable
  Decimal? paymentAmount;
  @observable
  String? paymentAsset;
  @observable
  Decimal? buyAmount;
  @observable
  String? buyAsset;
  @observable
  Decimal? depositFeeAmount;
  @observable
  String? depositFeeAsset;
  @observable
  Decimal? tradeFeeAmount;
  @observable
  String? tradeFeeAsset;
  @observable
  Decimal? rate;
  @observable
  String paymentId = '';
  @observable
  int actualTimeInSecond = 30;

  @observable
  bool deviceBindingRequired = false;

  @observable
  Decimal price = Decimal.zero;

  AnimationController? timerAnimation;
  @observable
  int timer = 0;
  @observable
  bool timerLoading = true;
  Timer _timer = Timer(Duration.zero, () {});

  @observable
  String cvv = '';
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
        (currency) => currency.symbol == (buyAsset ?? 'BTC'),
        orElse: () => CurrencyModel.empty(),
      );

  @computed
  CurrencyModel get payCurrency => sSignalRModules.currenciesWithHiddenList.firstWhere(
        (currency) => currency.symbol == paymentAsset,
        orElse: () => CurrencyModel.empty(),
      );

  @computed
  CurrencyModel get depositFeeCurrency => sSignalRModules.currenciesWithHiddenList.firstWhere(
        (currency) => currency.symbol == (depositFeeAsset ?? 'BTC'),
        orElse: () => CurrencyModel.empty(),
      );

  @computed
  CurrencyModel get tradeFeeCurreny => sSignalRModules.currenciesWithHiddenList.firstWhere(
        (currency) => currency.symbol == (tradeFeeAsset ?? 'BTC'),
        orElse: () => CurrencyModel.empty(),
      );

  String accountId = '';

  String accountLabel = '';

  bool isFromFixed = true;

  @action
  Future<void> loadPreview({
    required String fromAsset,
    required Decimal fromAmount,
    required String toAsset,
    required Decimal toAmount,
    required bool newIsFromFixed,
    required String newAccountId,
    required String newAccountLabel,
  }) async {
    isDataLoaded = false;

    loader.startLoadingImmediately();

    isFromFixed = newIsFromFixed;
    paymentAmount = fromAmount;
    paymentAsset = fromAsset;
    accountId = newAccountId;
    buyAsset = toAsset;
    buyAmount = toAmount;
    accountLabel = newAccountLabel;

    await _isChecked();

    await requestQuote();

    loader.finishLoadingImmediately();

    isDataLoaded = true;

    sAnalytics.sellOrderSummaryScreenView(
      destinationWallet: toAsset,
      cryptoAmount: paymentAmount.toString(),
      fiatAmount: buyAmount.toString(),
      sellFromWallet: paymentAsset ?? '',
      fiatAccountLabel: accountLabel,
      sellToPMType:
          accountId == 'clearjuction_account' ? PaymenthMethodType.cjAccount : PaymenthMethodType.unlimitAccount,
    );
  }

  @action
  Future<void> getActualData() async {
    if (terminateUpdates) return;

    try {
      if (accountId == 'clearjuction_account') {
        final model = GetQuoteRequestModel(
          isFromFixed: isFromFixed,
          fromAssetAmount: isFromFixed ? paymentAmount : null,
          fromAssetSymbol: paymentAsset ?? '',
          toAssetAmount: isFromFixed ? null : buyAmount,
          toAssetSymbol: buyAsset ?? '',
        );

        final response = await sNetwork.getWalletModule().postGetQuote(model);

        response.pick(
          onData: (data) {
            paymentAmount = data.fromAssetAmount;
            paymentAsset = data.fromAssetSymbol;
            buyAmount = data.toAssetAmount;
            buyAsset = data.toAssetSymbol;
            depositFeeAmount = Decimal.zero;
            depositFeeAsset = data.fromAssetSymbol;
            tradeFeeAmount = data.feeAmount;
            tradeFeeAsset = data.feeAsset;
            rate = data.price;

            paymentId = data.operationId;
            actualTimeInSecond = data.expirationTime;
            deviceBindingRequired = false;
          },
          onError: (error) {
            loader.finishLoadingImmediately();

            _showFailureScreen(error.cause);
          },
        );
      } else {
        final model = GetCryptoSellRequestModel(
          buyFixed: !isFromFixed,
          paymentAsset: paymentAsset ?? '',
          buyAsset: buyAsset ?? '',
          buyAmount: buyAmount ?? Decimal.zero,
          paymentAmount: paymentAmount ?? Decimal.zero,
          destinationAccountId: accountId,
        );

        final response = await sNetwork.getWalletModule().postSellCreate(model);

        response.pick(
          onData: (data) {
            paymentAmount = data.paymentAmount;
            paymentAsset = data.paymentAssetSymbol;
            buyAmount = data.buyAmount;
            buyAsset = data.buyAssetSymbol;
            depositFeeAmount = data.paymentFeeInPaymentAsset;
            depositFeeAsset = 'EUR';
            tradeFeeAmount = data.tradeFeeAmount;
            tradeFeeAsset = data.tradeFeeAsset;
            rate = data.rate;
            paymentId = data.id;
          },
          onError: (error) {
            loader.finishLoadingImmediately();

            _showFailureScreen(error.cause);
          },
        );
      }
    } on ServerRejectException catch (error) {
      loader.finishLoadingImmediately();

      unawaited(_showFailureScreen(error.cause));
    } catch (error) {
      loader.finishLoadingImmediately();

      unawaited(_showFailureScreen(intl.something_went_wrong));
    } finally {
      loader.finishLoadingImmediately();

      isDataLoaded = true;
    }
  }

  @action
  Future<void> _showFailureScreen(String error) async {
    loader.finishLoadingImmediately();

    errorHasHeppened = true;

    sAnalytics.failedSellEndScreenView(
      destinationWallet: 'EUR',
      cryptoAmount: paymentAmount.toString(),
      fiatAmount: buyAmount.toString(),
      sellFromWallet: paymentAsset ?? '',
      fiatAccountLabel: accountLabel,
      sellToPMType:
          accountId == 'clearjuction_account' ? PaymenthMethodType.cjAccount : PaymenthMethodType.unlimitAccount,
    );

    if (sRouter.currentPath != '/sell_confirmation') {
      return;
    }

    unawaited(
      sRouter.push(
        FailureScreenRouter(
          primaryText: intl.previewBuyWithAsset_failure,
          secondaryText: error,
          primaryButtonName: intl.previewBuyWithAsset_close,
          onPrimaryButtonTap: () {
            navigateToRouter();
          },
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
              baseAssetSymbol: buyAsset!,
              quotedAssetSymbol: paymentAsset!,
            ),
          ) ??
          Decimal.zero;

      await getActualData();

      _refreshTimerAnimation(actualTimeInSecond);
      _refreshTimer(actualTimeInSecond);
      timerLoading = false;
    } on ServerRejectException catch (error) {
      await _showFailureScreen(error.cause);
    } catch (error) {
      _refreshTimer(quoteRetryInterval);
    }
  }

  /// Will be triggered during initState of the parent widget
  @action
  void updateTimerAnimation(AnimationController controller) {
    timerAnimation = controller;
  }

  /// Will be triggered only when timerAnimation is not Null
  @action
  void _refreshTimerAnimation(int duration) {
    timerAnimation!.duration = Duration(seconds: duration.abs());
    timerAnimation!.countdown();
  }

  bool errorHasHeppened = false;

  @action
  void _refreshTimer(int initial) {
    _timer.cancel();
    timer = initial;

    if (errorHasHeppened) return;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (time) {
        if (timer == 0) {
          time.cancel();
          requestQuote();
        } else {
          timer = timer - 1;
        }
      },
    );
  }

  @action
  void cancelTimer() {
    _timer.cancel();
  }

  @action
  Future<void> createPayment() async {
    sAnalytics.tapOnTheButtonConfirmOnSellOrderSummary(
      destinationWallet: 'EUR',
      cryptoAmount: paymentAmount.toString(),
      fiatAmount: buyAmount.toString(),
      sellFromWallet: paymentAsset ?? '',
      fiatAccountLabel: accountLabel,
      sellToPMType:
          accountId == 'clearjuction_account' ? PaymenthMethodType.cjAccount : PaymenthMethodType.unlimitAccount,
    );

    unawaited(_setIsChecked());
    unawaited(_saveLastPaymentMethod());

    await _requestPaymentAccaunt();
  }

  @action
  Future<void> _requestPaymentAccaunt() async {
    var pin = '';
    try {
      termiteUpdate();

      if (accountId != 'clearjuction_account') {
        await sRouter.push(
          PinScreenRoute(
            union: const Change(),
            isChangePhone: true,
            onChangePhone: (String newPin) async {
              pin = newPin;
              await sRouter.maybePop();
            },
          ),
        );

        if (pin == '') return;
      }

      showProcessing = true;
      wasAction = true;

      if (deviceBindingRequired) {
        var isVerifaierd = false;

        await showDeviceBindingRequiredFlow(
          onConfirmed: () {
            isVerifaierd = true;
          },
        );

        if (!isVerifaierd) return;
      }

      loader.startLoadingImmediately();

      late DC<ServerRejectException, dynamic> resp;

      if (accountId == 'clearjuction_account') {
        final model = ExecuteQuoteRequestModel(
          isFromFixed: isFromFixed,
          operationId: paymentId,
          price: price,
          fromAssetSymbol: paymentAsset!,
          toAssetSymbol: buyAsset!,
          fromAssetAmount: paymentAmount,
          toAssetAmount: buyAmount,
        );

        resp = await sNetwork.getWalletModule().postExecuteQuote(model);
      } else {
        final model = ExecuteCryptoSellRequestModel(
          paymentId: paymentId,
        );

        resp = await sNetwork.getWalletModule().postSellExecute(
              model,
            );
      }

      if (resp.hasError) {
        await _showFailureScreen(resp.error?.cause ?? '');

        return;
      }

      if (sRouter.currentPath != '/sell_confirmation') {
        return;
      }

      if (isWaitingSkipped) {
        return;
      }
      unawaited(_showSuccessScreen(false));

      skippedWaiting();
    } on ServerRejectException catch (error) {
      unawaited(_showFailureScreen(error.cause));
    } catch (error) {
      unawaited(_showFailureScreen(intl.something_went_wrong));
    }
  }

  @action
  Future<void> _showSuccessScreen(bool isGoogle) {
    sAnalytics.successSellEndScreenView(
      destinationWallet: 'EUR',
      cryptoAmount: paymentAmount.toString(),
      fiatAmount: buyAmount.toString(),
      sellFromWallet: paymentAsset ?? '',
      fiatAccountLabel: accountLabel,
      sellToPMType:
          accountId == 'clearjuction_account' ? PaymenthMethodType.cjAccount : PaymenthMethodType.unlimitAccount,
    );

    return sRouter
        .push(
      SuccessScreenRouter(
        secondaryText: intl.sell_success_cryptocurrencies,
        buttonText: intl.previewBuyWithUmlimint_saveCard,
        showProgressBar: true,
      ),
    )
        .then((value) {
      sRouter.replaceAll([
        const HomeRouter(
          children: [
            MyWalletsRouter(),
          ],
        ),
      ]);

      shopRateUpPopup(sRouter.navigatorKey.currentContext!);
    });
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

  void skipProcessing() {}

  Future<void> _saveLastPaymentMethod() async {
    try {
      final storage = sLocalStorageService;

      await storage.setString(
        bankLastMethodId,
        accountId,
      );
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'BuyConfirmationStore',
            message: e.toString(),
          );
    }
  }
}
