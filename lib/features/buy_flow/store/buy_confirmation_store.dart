import 'dart:async';
import 'dart:developer';

import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_input.dart';
import 'package:jetwallet/core/services/conversion_price_service/conversion_price_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_bank_card_input.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/show_bank_card_cvv_bottom_sheet.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods_new.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_create/card_buy_create_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_execute/card_buy_execute_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_info/card_buy_info_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_info/card_buy_info_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';

part 'buy_confirmation_store.g.dart';

class BuyConfirmationStore extends _BuyConfirmationStoreBase
    with _$BuyConfirmationStore {
  BuyConfirmationStore() : super();

  static BuyConfirmationStore of(BuildContext context) =>
      Provider.of<BuyConfirmationStore>(context, listen: false);
}

abstract class _BuyConfirmationStoreBase with Store {
  @observable
  StackLoaderStore loader = StackLoaderStore();

  @observable
  PaymentMethodCategory category = PaymentMethodCategory.cards;

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

    print('cancel REQUESTS');
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
  int actualTimeInSecond = 0;

  @observable
  Decimal price = Decimal.zero;

  @observable
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

  @observable
  bool isLocalTermsChecked = false;
  @action
  void setIsLocalTermsChecked() {
    isLocalTermsChecked = !isLocalTermsChecked;
  }

  @observable
  bool isP2PTermsChecked = false;
  @action
  void seIsP2PTermsChecked() {
    isP2PTermsChecked = !isP2PTermsChecked;
  }

  @computed
  bool get getCheckbox {
    switch (category) {
      case PaymentMethodCategory.cards:
        return isBankTermsChecked;
      case PaymentMethodCategory.local:
        return isLocalTermsChecked;
      case PaymentMethodCategory.p2p:
        return isP2PTermsChecked;
      default:
        return isBankTermsChecked;
    }
  }

  @observable
  bool showProcessing = false;

  @computed
  CurrencyModel get buyCurrency =>
      sSignalRModules.currenciesWithHiddenList.firstWhere(
        (currency) => currency.symbol == (buyAssetSymbol ?? 'BTC'),
        orElse: () => CurrencyModel.empty(),
      );

  @computed
  CurrencyModel get depositFeeCurrency =>
      sSignalRModules.currenciesWithHiddenList.firstWhere(
        (currency) => currency.symbol == (depositFeeAsset ?? 'BTC'),
        orElse: () => CurrencyModel.empty(),
      );

  @computed
  CurrencyModel get tradeFeeCurreny =>
      sSignalRModules.currenciesWithHiddenList.firstWhere(
        (currency) => currency.symbol == (tradeFeeAsset ?? 'BTC'),
        orElse: () => CurrencyModel.empty(),
      );

  CircleCard? card;
  BuyMethodDto? method;
  String? buyAssetSymbol;
  String payAmount = '';
  String payAsset = '';

  @action
  Future<void> loadPreview(
    String pAmount,
    String bAsset,
    String pAsset,
    BuyMethodDto? inputMethod,
    CircleCard? inputCard,
  ) async {
    isDataLoaded = false;

    category =
        card == null ? inputMethod!.category! : PaymentMethodCategory.cards;

    loader.startLoadingImmediately();

    payAmount = pAmount;
    payAsset = pAsset;
    card = inputCard;
    method = inputMethod;
    buyAssetSymbol = bAsset;

    await _isChecked();

    await requestQuote();

    loader.finishLoadingImmediately();

    sAnalytics.newBuyTapContinue(
      sourceCurrency: buyCurrency.symbol,
      sourceAmount: paymentAmount.toString(),
      destinationCurrency: bAsset,
      paymentMethodType: category.name,
      paymentMethodName:
          category == PaymentMethodCategory.cards ? 'card' : method!.id.name,
      paymentMethodCurrency: buyCurrency.symbol ?? '',
      destinationAmount: '$buyAmount',
      quickAmount: '',
    );

    isDataLoaded = true;

    sAnalytics.newBuyOrderSummaryView(
      paymentMethodType: category.name,
      paymentMethodName:
          category == PaymentMethodCategory.cards ? 'card' : method!.id.name,
      paymentMethodCurrency: buyCurrency.symbol ?? '',
    );
  }

  @action
  Future<void> getActualData() async {
    if (terminateUpdates) return;

    final model = getModelForCardBuyReq(
        category, payAmount, buyAssetSymbol ?? '', payAsset);

    try {
      final response =
          await sNetwork.getWalletModule().postCardBuyCreate(model);

      response.pick(
        onData: (data) {
          paymentAmount = data.paymentAmount;
          paymentAsset = data.paymentAsset;
          buyAmount = data.buyAmount;
          buyAsset = data.buyAsset;
          depositFeeAmount = data.depositFeeAmount;
          depositFeeAsset = data.depositFeeAsset;
          tradeFeeAmount = data.tradeFeeAmount;
          tradeFeeAsset = data.tradeFeeAsset;
          rate = data.rate;
          paymentId = data.paymentId ?? '';
          actualTimeInSecond = data.actualTimeInSecond ?? 15;
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

  CardBuyCreateRequestModel getModelForCardBuyReq(
    PaymentMethodCategory category,
    String pAmount,
    String bAsset,
    String pAsset,
  ) {
    switch (category) {
      case PaymentMethodCategory.cards:
        return CardBuyCreateRequestModel(
          paymentMethod: convertMethodToCirclePaymentMethod(method!),
          paymentAmount: Decimal.parse(pAmount),
          buyAsset: bAsset,
          paymentAsset: pAsset,
          cardPaymentData: CirclePaymentDataModel(cardId: card!.id),
        );
      case PaymentMethodCategory.local:
        return CardBuyCreateRequestModel(
          paymentMethod: convertMethodToCirclePaymentMethod(method!),
          paymentAmount: Decimal.parse(pAmount),
          buyAsset: bAsset,
          paymentAsset: pAsset,
        );
      default:
        return CardBuyCreateRequestModel(
          paymentMethod: convertMethodToCirclePaymentMethod(method!),
          paymentAmount: Decimal.parse(pAmount),
          buyAsset: bAsset,
          paymentAsset: pAsset,
        );
    }
  }

  @action
  Future<void> _showFailureScreen(String error) async {
    loader.finishLoadingImmediately();

    sAnalytics.newBuyFailedView(
      errorCode: error,
      firstTimeBuy: '$firstBuy',
      paymentMethodType: category.name,
      paymentMethodName:
          category == PaymentMethodCategory.cards ? 'card' : method!.id.name,
      paymentMethodCurrency: buyCurrency.symbol ?? '',
    );

    if (sRouter.currentPath != '/buy_flow_confirmation') {
      return;
    }

    unawaited(sRouter.push(
      FailureScreenRouter(
        primaryText: intl.previewBuyWithAsset_failure,
        secondaryText: error,
        primaryButtonName: intl.previewBuyWithAsset_close,
        onPrimaryButtonTap: () {
          navigateToRouter();
        },
      ),
    ));
  }

  @action
  Future<void> requestQuote() async {
    if (terminateUpdates) return;

    try {
      await getActualData();

      price = await getConversionPrice(
            ConversionPriceInput(
              baseAssetSymbol: buyAsset!,
              quotedAssetSymbol: paymentAsset!,
            ),
          ) ??
          Decimal.zero;

      if (category == PaymentMethodCategory.cards) {
        _refreshTimerAnimation(actualTimeInSecond);
        _refreshTimer(actualTimeInSecond);
      }
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

  @action
  void _refreshTimer(int initial) {
    _timer.cancel();
    timer = initial;

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
    sAnalytics.newBuyTapConfirm(
      sourceCurrency: buyCurrency.symbol,
      destinationCurrency: buyAssetSymbol ?? '',
      sourceAmount: '$paymentAmount',
      destinationAmount: '$buyAmount',
      exchangeRate: '1 $buyAssetSymbol = ${volumeFormat(
        prefix: buyCurrency.prefixSymbol,
        symbol: buyCurrency.symbol,
        accuracy: buyCurrency.accuracy,
        decimal: rate ?? Decimal.zero,
      )}',
      paymentFee: '$depositFeeAmount',
      firstTimeBuy: '$firstBuy',
      paymentMethodType: category.name,
      paymentMethodName:
          category == PaymentMethodCategory.cards ? 'card' : method!.id.name,
      paymentMethodCurrency: buyCurrency.symbol ?? '',
    );

    unawaited(_setIsChecked());
    unawaited(_saveLastPaymentMethod());

    if (category == PaymentMethodCategory.cards) {
      sAnalytics.newBuyEnterCvvView(firstTimeBuy: '$firstBuy');

      showBankCardCvvBottomSheet(
        context: sRouter.navigatorKey.currentContext!,
        header: '${intl.previewBuyWithCircle_enter} CVV \n'
            '${intl.previewBuyWithCircle_for} '
            '${card!.network.name}'
            ' •••• ${card!.last4}',
        onCompleted: (cvvNew) {
          cvv = cvvNew;
          sRouter.pop();

          _requestPaymentCard();
        },
        onDissmis: () {},
        input: PreviewBuyWithBankCardInput(
          amount: paymentAmount.toString(),
          currency: depositFeeCurrency,
          cardId: card!.id,
          cardNumber: card!.last4,
          currencyPayment: depositFeeCurrency,
          quickAmount: 'false',
        ),
      );
    } else {
      await _requestPaymentLocal();
    }

    //await setLastUsedPaymentMethod();
  }

  @action
  Future<void> _requestPaymentLocal() async {
    showProcessing = true;
    wasAction = true;

    loader.startLoadingImmediately();

    termiteUpdate();

    try {
      final model = CardBuyExecuteRequestModel(
        paymentId: paymentId,
        paymentMethod: convertMethodToCirclePaymentMethod(method!),
      );

      final resp = await sNetwork.getWalletModule().postCardBuyExecute(
            model,
            cancelToken: cancelToken,
          );

      if (resp.hasError) {
        unawaited(_showFailureScreen(resp.error?.cause ?? ''));

        return;
      } else {
        final model = CardBuyInfoRequestModel(
          paymentId: paymentId,
        );

        final response =
            await sNetwork.getWalletModule().postCardBuyInfo(model);
        if (response.hasError) {
          unawaited(_showFailureScreen(resp.error?.cause ?? ''));

          return;
        } else {
          sAnalytics.paymentWevViewScreenView(
            paymentMethodType: category.name,
            paymentMethodName: category == PaymentMethodCategory.cards
                ? 'card'
                : method!.id.name,
            paymentMethodCurrency: buyCurrency.symbol ?? '',
          );

          if (sRouter.currentPath != '/buy_flow_confirmation') {
            return;
          }

          await sRouter.push(
            Circle3dSecureWebViewRouter(
              title: '',
              url: response.data!.clientAction!.checkoutUrl ?? '',
              asset: depositFeeCurrency.symbol,
              amount: paymentAmount.toString(),
              onSuccess: (payment, lastAction) {
                loader.finishLoadingImmediately();
                Navigator.pop(sRouter.navigatorKey.currentContext!);

                loader.startLoadingImmediately();

                showProcessing = true;
                paymentId = payment;
                wasAction = true;

                sAnalytics.newBuyProcessingView(
                  firstTimeBuy: '$firstBuy',
                  paymentMethodType: category.name,
                  paymentMethodName: category == PaymentMethodCategory.cards
                      ? 'card'
                      : method!.id.name,
                  paymentMethodCurrency: buyCurrency.symbol ?? '',
                );

                loader.startLoadingImmediately();
                //_requestPaymentInfo(onAction, lastAction);
              },
              onCancel: (payment) {
                sRouter.pop();
              },
              onFailed: (error) {
                sRouter.pop();
                _showFailureScreen(error);
              },
              paymentId: paymentId,
            ),
          );
        }
      }
    } on ServerRejectException catch (error) {
      unawaited(_showFailureScreen(error.cause));
    } catch (error) {
      unawaited(_showFailureScreen(intl.something_went_wrong));
    }
  }

  @action
  Future<void> _requestPaymentCard() async {
    try {
      termiteUpdate();

      final response = await sNetwork.getWalletModule().encryptionKey();

      final rsa = RsaKeyHelper();
      final key = '-----BEGIN RSA PUBLIC KEY-----\r\n'
          '${response.data?.data.key}'
          '\r\n-----END RSA PUBLIC KEY-----';
      final key1 = rsa.parsePublicKeyFromPem(key);
      final encrypter = Encrypter(RSA(publicKey: key1));
      final encryptedCvv = encrypter.encrypt('{"cvv":"$cvv"}');
      final base64EncodedCvv = encryptedCvv.base64;

      log(method!.toString());

      final model = CardBuyExecuteRequestModel(
        paymentId: paymentId,
        paymentMethod: convertMethodToCirclePaymentMethod(method!),
        cardPaymentData: BankCardPaymentDataExecuteModel(
          cardId: card?.id,
          encKeyId: response.data?.data.keyId,
          encData: base64EncodedCvv,
        ),
      );

      showProcessing = true;
      wasAction = true;

      sAnalytics.newBuyProcessingView(
        firstTimeBuy: '$firstBuy',
        paymentMethodType: category.name,
        paymentMethodName:
            category == PaymentMethodCategory.cards ? 'card' : method!.id.name,
        paymentMethodCurrency: buyCurrency.symbol ?? '',
      );

      loader.startLoadingImmediately();

      final resp = await sNetwork.getWalletModule().postCardBuyExecute(
            model,
            cancelToken: cancelToken,
          );

      if (resp.hasError) {
        await _showFailureScreen(resp.error?.cause ?? '');

        return;
      }

      if (sRouter.currentPath != '/buy_flow_confirmation') {
        return;
      }

      await _requestPaymentInfo(
        (url, onSuccess, onCancel, onFailed, paymentId) {
          _setIsChecked();

          sAnalytics.paymentWevViewScreenView(
            paymentMethodType: category.name,
            paymentMethodName: category == PaymentMethodCategory.cards
                ? 'card'
                : method!.id.name,
            paymentMethodCurrency: buyCurrency.symbol ?? '',
          );

          sRouter.push(
            Circle3dSecureWebViewRouter(
              title: intl.previewBuyWithCircle_paymentVerification,
              url: url,
              asset: depositFeeCurrency.symbol,
              amount: paymentAmount.toString(),
              onSuccess: onSuccess,
              onFailed: onFailed,
              onCancel: onCancel,
              paymentId: paymentId,
            ),
          );

          loader.finishLoadingImmediately();
          showProcessing = true;
          wasAction = true;
          loader.startLoadingImmediately();

          sAnalytics.newBuyProcessingView(
            firstTimeBuy: '$firstBuy',
            paymentMethodType: category.name,
            paymentMethodName: category == PaymentMethodCategory.cards
                ? 'card'
                : method!.id.name,
            paymentMethodCurrency: buyCurrency.symbol ?? '',
          );
        },
        '',
      );

      //onSuccess();
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
      Function(String),
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
          print(data.status);

          final pending = data.status == CardBuyPaymentStatus.inProcess ||
              data.status == CardBuyPaymentStatus.preview ||
              data.status == CardBuyPaymentStatus.waitForPayment;
          final complete = data.status == CardBuyPaymentStatus.success;
          final failed = data.status == CardBuyPaymentStatus.fail;
          final actionRequired =
              data.status == CardBuyPaymentStatus.requireAction;

          if (pending ||
              (actionRequired &&
                  lastAction == data.clientAction!.checkoutUrl)) {
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
                sAnalytics.paymentWevViewClose(
                  paymentMethodType: category.name,
                  paymentMethodName: category == PaymentMethodCategory.cards
                      ? 'card'
                      : method!.id.name,
                  paymentMethodCurrency: buyCurrency.symbol ?? '',
                );

                sRouter.pop();
              },
              (error) {
                sRouter.pop();
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
    sAnalytics.newBuySuccessView(
      firstTimeBuy: '$firstBuy',
      paymentMethodType: category.name,
      paymentMethodName:
          category == PaymentMethodCategory.cards ? 'card' : method!.id.name,
      paymentMethodCurrency: buyCurrency.symbol ?? '',
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
          ),
        )
        .then(
          (value) => sRouter.replaceAll([
            const HomeRouter(
              children: [
                PortfolioRouter(),
              ],
            ),
          ]),
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

      switch (category) {
        case PaymentMethodCategory.cards:
          final status = await storage.getValue(checkedBankCard);
          if (status != null) {
            isBankTermsChecked = true;
          } else {
            firstBuy = true;
          }
          break;
        case PaymentMethodCategory.local:
          final status = await storage.getValue(checkedLocalTerms);
          if (status != null) {
            isLocalTermsChecked = true;
          }
          break;
        case PaymentMethodCategory.p2p:
          final status = await storage.getValue(checkedP2PTerms);
          if (status != null) {
            isP2PTermsChecked = true;
          }
          break;
        default:
      }
    } catch (e) {}
  }

  @action
  Future<void> _setIsChecked() async {
    try {
      final storage = sLocalStorageService;

      switch (category) {
        case PaymentMethodCategory.cards:
          await storage.setString(checkedBankCard, 'true');
          isBankTermsChecked = true;
          break;
        case PaymentMethodCategory.local:
          await storage.setString(checkedLocalTerms, 'true');
          isLocalTermsChecked = true;
          break;
        case PaymentMethodCategory.p2p:
          await storage.setString(checkedP2PTerms, 'true');
          isP2PTermsChecked = true;
          break;
        default:
      }
    } catch (e) {}
  }

  @computed
  String get getProcessingText {
    switch (category) {
      case PaymentMethodCategory.cards:
        return '';
      case PaymentMethodCategory.local:
        return intl.buy_confirmation_local_p2p_processing_text;
      case PaymentMethodCategory.p2p:
        return intl.buy_confirmation_local_p2p_processing_text;
      default:
        return '';
    }
  }

  void skipProcessing() {
    sAnalytics.newBuyTapCloseProcessing(
      firstTimeBuy: '$firstBuy',
      paymentMethodType: category.name,
      paymentMethodName:
          category == PaymentMethodCategory.cards ? 'card' : method!.id.name,
      paymentMethodCurrency: buyCurrency.symbol ?? '',
    );
  }

  Future<void> _saveLastPaymentMethod() async {
    try {
      final storage = sLocalStorageService;

      switch (category) {
        case PaymentMethodCategory.cards:
          await storage.setString(bankLastMethodId, card?.id ?? '');
          break;
        case PaymentMethodCategory.local:
          await storage.setString(
            localLastMethodId,
            method?.id.toString() ?? '',
          );
          break;
        case PaymentMethodCategory.p2p:
          await storage.setString(p2pLastMethodId, method?.id.toString() ?? '');
          break;
        default:
      }
    } catch (e) {}
  }
}

CirclePaymentMethod convertMethodToCirclePaymentMethod(BuyMethodDto method) {
  switch (method.id) {
    case PaymentMethodType.bankCard:
      return CirclePaymentMethod.bankCard;
    case PaymentMethodType.unlimintAlternative:
      return CirclePaymentMethod.unlimintAlr;
    case PaymentMethodType.unlimintCard:
      return CirclePaymentMethod.unlimint;
    case PaymentMethodType.pix:
      return CirclePaymentMethod.pix;
    case PaymentMethodType.picpay:
      return CirclePaymentMethod.picpay;
    case PaymentMethodType.convenienceStore:
      return CirclePaymentMethod.convenienceStore;
    case PaymentMethodType.codi:
      return CirclePaymentMethod.codi;
    case PaymentMethodType.spei:
      return CirclePaymentMethod.spei;
    case PaymentMethodType.oxxo:
      return CirclePaymentMethod.oxxo;
    case PaymentMethodType.efecty:
      return CirclePaymentMethod.efecty;
    case PaymentMethodType.baloto:
      return CirclePaymentMethod.baloto;
    case PaymentMethodType.davivienda:
      return CirclePaymentMethod.davivienda;
    case PaymentMethodType.pagoEfectivo:
      return CirclePaymentMethod.pagoEfectivo;
    case PaymentMethodType.directBankingEurope:
      return CirclePaymentMethod.directBankingEurope;
    case PaymentMethodType.paymeP2P:
      return CirclePaymentMethod.paymeP2P;
    default:
      return CirclePaymentMethod.bankCard;
  }
}
