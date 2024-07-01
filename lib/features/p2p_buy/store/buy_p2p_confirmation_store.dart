import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/app/store/app_store.dart';
import 'package:jetwallet/utils/device_binding_required_flow/show_device_binding_required_flow.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
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
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_create/card_buy_create_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_execute/card_buy_execute_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_info/card_buy_info_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_info/card_buy_info_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/p2p_methods/p2p_methods_responce_model.dart';
import 'package:simple_networking/modules/wallet_api/models/p2p_methods/p2p_payment_data.dart';

part 'buy_p2p_confirmation_store.g.dart';

class BuyP2PConfirmationStore extends _BuyP2PConfirmationStoreBase with _$BuyP2PConfirmationStore {
  BuyP2PConfirmationStore() : super();

  static BuyP2PConfirmationStore of(BuildContext context) =>
      Provider.of<BuyP2PConfirmationStore>(context, listen: false);
}

abstract class _BuyP2PConfirmationStoreBase with Store {
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
  Future<void> cancelAllRequest() async {
    cancelToken.cancel('exit');

    getIt<AppStore>().generateNewSessionID();
    await getIt.get<SNetwork>().init(getIt<AppStore>().sessionID);

    getIt.get<SimpleLoggerService>().log(
          level: Level.info,
          place: 'Buy Confirmation Store',
          message: 'cancel REQUESTS',
        );
  }

  @observable
  Decimal? paymentAmount;

  @observable
  Decimal? buyAmount;
  @observable
  String? buyAsset;
  @observable
  PaymentAsset? paymentAsset;
  @observable
  P2PMethodModel? p2pMethod;

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
  int actualTimeInSecond = 0;

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
  bool isWaitingSkipped = false;
  @observable
  bool wasAction = false;

  @observable
  bool showProcessing = false;

  @computed
  CurrencyModel get buyCurrency => sSignalRModules.currenciesWithHiddenList.firstWhere(
        (currency) => currency.symbol == (buyAsset ?? 'BTC'),
        orElse: () => CurrencyModel.empty(),
      );

  @computed
  CurrencyModel get payCurrency => sSignalRModules.currenciesWithHiddenList.firstWhere(
        (currency) => currency.symbol == 'EUR',
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

  @computed
  String get paymentAssetSumbol => paymentAsset?.asset ?? '';

  bool isFromFixed = true;

  @action
  Future<void> loadPreview({
    String? pAmount,
    String? bAmount,
    required String bAsset,
    required bool inputIsFromFixed,
    required PaymentAsset inputPaymentAsset,
    required P2PMethodModel inputP2pMethod,
  }) async {
    isFromFixed = inputIsFromFixed;
    paymentAmount = Decimal.parse(pAmount ?? '0');

    buyAsset = bAsset;
    buyAmount = Decimal.parse(bAmount ?? '0');

    paymentAsset = inputPaymentAsset;
    p2pMethod = inputP2pMethod;

    isDataLoaded = false;
    loader.startLoadingImmediately();

    await requestQuote();

    loader.finishLoadingImmediately();

    isDataLoaded = true;

    sAnalytics.buyOrderSummaryScreenView(
      pmType: PaymenthMethodType.ptp,
      buyPM: 'PTP',
      sourceCurrency: paymentAsset?.asset ?? '',
      destinationWallet: buyAsset ?? '',
      sourceBuyAmount: paymentAmount.toString(),
      destinationBuyAmount: buyAmount.toString(),
    );
  }

  @action
  Future<void> getActualData() async {
    if (terminateUpdates) return;

    try {
      final model = CardBuyCreateRequestModel(
        paymentAmount: paymentAmount,
        buyAmount: buyAmount,
        buyAsset: buyAsset ?? '',
        paymentAsset: paymentAssetSumbol,
        buyFixed: !isFromFixed,
        paymentMethod: CirclePaymentMethod.paymeP2P,
        p2PPaymentData: P2PPaymentData(
          receiveMethodId: p2pMethod?.methodId ?? '',
        ),
      );

      final response = await sNetwork.getWalletModule().postCardBuyCreate(model);

      response.pick(
        onData: (data) {
          paymentAmount = data.paymentAmount;
          buyAmount = data.buyAmount;
          buyAsset = data.buyAsset;
          depositFeeAmount = data.depositFeeAmount;
          depositFeeAsset = data.depositFeeAsset;
          tradeFeeAmount = data.tradeFeeAmount;
          tradeFeeAsset = data.tradeFeeAsset;
          rate = data.rate;
          paymentId = data.paymentId ?? '';
          actualTimeInSecond = data.actualTimeInSecond;
          deviceBindingRequired = data.deviceBindingRequired;
        },
        onError: (error) {
          loader.finishLoadingImmediately();

          _showFailureScreen(error.cause);
        },
      );
    } on ServerRejectException catch (error) {
      unawaited(_showFailureScreen(error.cause));
    } catch (error) {
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

    if (sRouter.currentPath != '/buy_p2p_confirmation') {
      return;
    }

    sAnalytics.failedBuyEndScreenView(
      pmType: PaymenthMethodType.ptp,
      buyPM: 'PTP',
      sourceCurrency: paymentAsset?.asset ?? '',
      destinationWallet: buyAsset ?? '',
      sourceBuyAmount: paymentAmount.toString(),
      destinationBuyAmount: buyAmount.toString(),
    );

    unawaited(
      sRouter.push(
        FailureScreenRouter(
          primaryText: intl.previewBuyWithAsset_failure,
          secondaryText: error,
          primaryButtonName: intl.previewBuyWithAsset_close,
          onPrimaryButtonTap: () {
            sAnalytics.tapOnTheCloseButtonOnFailedBuyEndScreen(
              pmType: PaymenthMethodType.ptp,
              buyPM: 'PTP',
              sourceCurrency: paymentAsset?.asset ?? '',
              destinationWallet: buyAsset ?? '',
              sourceBuyAmount: paymentAmount.toString(),
              destinationBuyAmount: buyAmount.toString(),
            );
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
              quotedAssetSymbol: paymentAssetSumbol,
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
    await _requestPaymentAccaunt();
  }

  @action
  Future<void> _requestPaymentAccaunt() async {
    try {
      termiteUpdate();

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

      final model = CardBuyExecuteRequestModel(
        paymentId: paymentId,
        paymentMethod: CirclePaymentMethod.paymeP2P,
        p2PPaymentData: P2PPaymentData(
          receiveMethodId: p2pMethod?.methodId ?? '',
        ),
      );

      final resp = await sNetwork.getWalletModule().postCardBuyExecute(
            model,
            cancelToken: cancelToken,
          );

      if (resp.hasError) {
        await _showFailureScreen(resp.error?.cause ?? '');

        return;
      }

      if (sRouter.currentPath != '/buy_p2p_confirmation') {
        return;
      }

      await _requestPaymentInfo(
        (url, onSuccess, onCancel, onFailed, paymentId) {
          sAnalytics.threeDSecureScreenView(
            pmType: PaymenthMethodType.ptp,
            buyPM: 'PTP',
            sourceCurrency: paymentAsset?.asset ?? '',
            destinationWallet: buyAsset ?? '',
            sourceBuyAmount: paymentAmount.toString(),
            destinationBuyAmount: buyAmount.toString(),
          );

          sRouter.push(
            Circle3dSecureWebViewRouter(
              title: intl.previewBuyWithCircle_paymentVerification,
              url: url,
              asset: depositFeeCurrency.symbol,
              amount: paymentAmount.toString(),
              onSuccess: onSuccess,
              onFailed: onFailed,
              onCancel: (text) {
                sAnalytics.tapOnTheCloseButtonOn3DSecureScreen(
                  pmType: PaymenthMethodType.ptp,
                  buyPM: 'PTP',
                  sourceCurrency: paymentAsset?.asset ?? '',
                  destinationWallet: buyAsset ?? '',
                  sourceBuyAmount: paymentAmount.toString(),
                  destinationBuyAmount: buyAmount.toString(),
                );
                onCancel.call(text);
              },
              paymentId: paymentId,
            ),
          );

          loader.finishLoadingImmediately();
          showProcessing = true;
          wasAction = true;
          loader.startLoadingImmediately();
        },
        '',
      );

      if (isWaitingSkipped) {
        return;
      }
    } on ServerRejectException catch (error) {
      unawaited(_showFailureScreen(error.cause));
    } catch (error) {
      unawaited(_showFailureScreen(intl.something_went_wrong));
    }
  }

  @action
  Future<void> _requestPaymentInfo(
    Function(
      String,
      Function(String, String),
      Function(String?),
      Function(String),
      String,
    ) onAction,
    String lastAction,
  ) async {
    try {
      final model = CardBuyInfoRequestModel(
        paymentId: paymentId,
      );

      final response = await sNetwork.getWalletModule().postCardBuyInfo(
            model,
            cancelToken: cancelToken,
          );

      response.pick(
        onData: (data) async {
          getIt.get<SimpleLoggerService>().log(
                level: Level.info,
                place: 'Buy Confirmation Store',
                message: data.status.name,
              );

          final pending = data.status == CardBuyPaymentStatus.inProcess ||
              data.status == CardBuyPaymentStatus.preview ||
              data.status == CardBuyPaymentStatus.waitForPayment;
          final complete = data.status == CardBuyPaymentStatus.success;
          final failed = data.status == CardBuyPaymentStatus.fail;
          final actionRequired = data.status == CardBuyPaymentStatus.requireAction;

          if (pending || (actionRequired && lastAction == data.clientAction!.checkoutUrl)) {
            if (isWaitingSkipped) {
              return;
            }
            await Future.delayed(const Duration(seconds: 1));
            await _requestPaymentInfo(onAction, lastAction);
          } else if (complete) {
            if (isWaitingSkipped) {
              return;
            }
            if (data.buyInfo != null) {
              buyAmount = data.buyInfo!.buyAmount;
            }
            unawaited(_showSuccessScreen(false));

            skippedWaiting();
          } else if (failed) {
            if (isWaitingSkipped) {
              return;
            }
            skippedWaiting();
            throw Exception();
          } else if (actionRequired) {
            if (isWaitingSkipped) {
              return;
            }
            onAction(
              data.clientAction!.checkoutUrl ?? '',
              (payment, lastAction) {
                Navigator.pop(sRouter.navigatorKey.currentContext!);
                paymentId = payment;
                showProcessing = true;
                wasAction = true;

                loader.startLoadingImmediately();
                _requestPaymentInfo(onAction, lastAction);
              },
              (payment) {
                if (payment != null) {
                  sRouter.maybePop();
                }
              },
              (error) {
                Navigator.pop(sRouter.navigatorKey.currentContext!);

                _showFailureScreen(error);
              },
              paymentId,
            );
          }
        },
        onError: (error) {
          _showFailureScreen(error.cause);
        },
      );
    } on ServerRejectException catch (error) {
      unawaited(_showFailureScreen(error.cause));
    } catch (error) {
      unawaited(_showFailureScreen(intl.something_went_wrong));
    }
  }

  @action
  Future<void> _showSuccessScreen(bool isGoogle) {
    sAnalytics.successBuyEndScreenView(
      pmType: PaymenthMethodType.ptp,
      buyPM: 'PTP',
      sourceCurrency: paymentAsset?.asset ?? '',
      destinationWallet: buyAsset ?? '',
      sourceBuyAmount: paymentAmount.toString(),
      destinationBuyAmount: buyAmount.toString(),
    );
    return sRouter
        .push(
      SuccessScreenRouter(
        secondaryText: isGoogle
            ? '${intl.successScreen_youBought} '
                '${volumeFormat(
                decimal: buyAmount ?? Decimal.zero,
                accuracy: buyCurrency.accuracy,
                symbol: buyCurrency.symbol,
              )}'
                '\n${intl.paid_with_gpay}'
            : '${intl.successScreen_youBought} '
                '${volumeFormat(
                decimal: buyAmount ?? Decimal.zero,
                accuracy: buyCurrency.accuracy,
                symbol: buyCurrency.symbol,
              )}',
        buttonText: intl.previewBuyWithUmlimint_saveCard,
        showProgressBar: true,
        showCloseButton: true,
        onCloseButton: () {
          sAnalytics.tapOnTheCloseButtonOnSuccessBuyEndScreen(
            pmType: PaymenthMethodType.ptp,
            buyPM: 'PTP',
            sourceCurrency: paymentAsset?.asset ?? '',
            destinationWallet: buyAsset ?? '',
            sourceBuyAmount: paymentAmount.toString(),
            destinationBuyAmount: buyAmount.toString(),
          );
          sRouter.replaceAll([
            const HomeRouter(
              children: [],
            ),
          ]);
        },
      ),
    )
        .then(
      (value) {
        sRouter.replaceAll([
          const HomeRouter(
            children: [],
          ),
        ]);

        shopRateUpPopup(sRouter.navigatorKey.currentContext!);
      },
    );
  }

  @action
  void skippedWaiting() {
    isWaitingSkipped = true;
  }

  @computed
  String get getProcessingText {
    return intl.buy_confirmation_local_p2p_processing_text;
  }
}
