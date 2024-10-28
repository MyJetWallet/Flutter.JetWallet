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
import 'package:jetwallet/features/home/store/bottom_bar_store.dart';
import 'package:jetwallet/utils/helpers/rate_up/show_rate_up_popup.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/swap_execute_quote/execute_quote_request_model.dart';

part 'convert_confirmation_store.g.dart';

class ConvertConfirmationStore extends _ConvertConfirmationStoreBase with _$ConvertConfirmationStore {
  ConvertConfirmationStore() : super();

  static ConvertConfirmationStore of(BuildContext context) =>
      Provider.of<ConvertConfirmationStore>(context, listen: false);
}

abstract class _ConvertConfirmationStoreBase with Store {
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
  bool firstBuy = false;

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

  bool isFromFixed = true;

  @action
  Future<void> loadPreview({
    required String fromAsset,
    required Decimal fromAmount,
    required String toAsset,
    required Decimal toAmount,
    required bool newIsFromFixed,
  }) async {
    isDataLoaded = false;

    loader.startLoadingImmediately();

    isFromFixed = newIsFromFixed;
    paymentAmount = fromAmount;
    paymentAsset = fromAsset;
    buyAsset = toAsset;
    buyAmount = toAmount;

    await requestQuote();

    loader.finishLoadingImmediately();

    sAnalytics.convertOrderSummaryScreenView(
      enteredAmount: (isFromFixed ? paymentAmount : buyAmount).toString(),
      convertFromAsset: paymentAsset ?? '',
      convertToAsset: buyAsset ?? '',
      nowInput: isFromFixed ? 'ConvertFrom' : 'ConvertTo',
    );

    isDataLoaded = true;
  }

  @action
  Future<void> getActualData() async {
    if (terminateUpdates) return;

    try {
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

    sAnalytics.failedConvertEndScreenView(
      enteredAmount: (isFromFixed ? paymentAmount : buyAmount).toString(),
      convertFromAsset: paymentAsset ?? '',
      convertToAsset: buyAsset ?? '',
      nowInput: isFromFixed ? 'ConvertFrom' : 'ConvertTo',
      errorText: error,
    );

    if (sRouter.currentPath != '/convert_confirmation') {
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
    unawaited(_saveLastPaymentMethod());

    await _requestPaymentAccaunt();
  }

  @action
  Future<void> _requestPaymentAccaunt() async {
    try {
      termiteUpdate();

      showProcessing = true;
      wasAction = true;
      loader.startLoadingImmediately();

      late DC<ServerRejectException, dynamic> resp;

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

      if (resp.hasError) {
        await _showFailureScreen(resp.error?.cause ?? '');

        return;
      }

      if (sRouter.currentPath != '/convert_confirmation') {
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
    sAnalytics.successConvertEndScreenView(
      enteredAmount: (isFromFixed ? paymentAmount : buyAmount).toString(),
      convertFromAsset: paymentAsset ?? '',
      convertToAsset: buyAsset ?? '',
      nowInput: isFromFixed ? 'ConvertFrom' : 'ConvertTo',
    );

    return sRouter.push(SuccessScreenRouter()).then((value) {
      sRouter.replaceAll([
        const HomeRouter(
          children: [
            MyWalletsRouter(),
          ],
        ),
      ]);
      getIt.get<BottomBarStore>().setHomeTab(BottomItemType.home);

      shopRateUpPopup(sRouter.navigatorKey.currentContext!);
    });
  }

  @action
  void skippedWaiting() {
    isWaitingSkipped = true;
  }

  void skipProcessing() {}

  Future<void> _saveLastPaymentMethod() async {
    try {
      final storage = sLocalStorageService;

      await storage.setString(
        bankLastMethodId,
        '',
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
