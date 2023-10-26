import 'dart:async';

import 'package:data_channel/data_channel.dart';
import 'package:decimal/decimal.dart';
import 'package:dio/dio.dart';
import 'package:encrypt/encrypt.dart';
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
import 'package:jetwallet/core/services/user_info/user_info_service.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_bank_card_input.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/show_bank_card_cvv_bottom_sheet.dart';
import 'package:jetwallet/features/phone_verification/ui/phone_verification.dart';
import 'package:jetwallet/features/pin_screen/model/pin_flow_union.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/country_code_by_user_register.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/signal_r/models/banking_profile_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_create/card_buy_create_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_execute/card_buy_execute_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_info/card_buy_info_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_info/card_buy_info_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/swap_execute_quote/execute_quote_request_model.dart';

part 'buy_confirmation_store.g.dart';

class BuyConfirmationStore extends _BuyConfirmationStoreBase with _$BuyConfirmationStore {
  BuyConfirmationStore() : super();

  static BuyConfirmationStore of(BuildContext context) => Provider.of<BuyConfirmationStore>(context, listen: false);
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
        (currency) => currency.symbol == (buyAssetSymbol ?? 'BTC'),
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

  CircleCard? card;
  SimpleBankingAccount? account;
  String? buyAssetSymbol;
  String payAmount = '';
  String payAsset = '';

  @action
  Future<void> loadPreview({
    required String pAmount,
    required String bAsset,
    CircleCard? inputCard,
    SimpleBankingAccount? inputAccount,
  }) async {
    isDataLoaded = false;

    category = inputCard == null ? PaymentMethodCategory.account : PaymentMethodCategory.cards;

    loader.startLoadingImmediately();

    payAmount = pAmount;
    payAsset = account?.currency ?? 'EUR';
    card = inputCard;
    account = inputAccount;
    buyAssetSymbol = bAsset;

    await _isChecked();

    await requestQuote();

    loader.finishLoadingImmediately();

    sAnalytics.newBuyTapContinue(
      sourceCurrency: depositFeeCurrency.symbol,
      sourceAmount: paymentAmount.toString(),
      destinationCurrency: buyAssetSymbol ?? '',
      paymentMethodType: category.name,
      paymentMethodName: category == PaymentMethodCategory.cards ? 'card' : 'account',
      paymentMethodCurrency: depositFeeCurrency.symbol,
      destinationAmount: '$buyAmount',
      quickAmount: 'false',
    );

    isDataLoaded = true;

    sAnalytics.newBuyOrderSummaryView(
      paymentMethodType: category.name,
      paymentMethodName: category == PaymentMethodCategory.cards ? 'card' : 'account',
      paymentMethodCurrency: depositFeeCurrency.symbol,
    );
  }

  @action
  Future<void> getActualData() async {
    if (terminateUpdates) return;

    try {
      if (account?.accountId == 'clearjuction_account') {
        final model = GetQuoteRequestModel(
          fromAssetAmount: Decimal.parse(payAmount),
          fromAssetSymbol: payAsset,
          toAssetSymbol: buyAssetSymbol ?? '',
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
        final model = getModelForCardBuyReq(
          category: category,
          pAmount: payAmount,
          bAsset: buyAssetSymbol ?? '',
          pAsset: payAsset,
        );

        final response = await sNetwork.getWalletModule().postCardBuyCreate(model);

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
            actualTimeInSecond = data.actualTimeInSecond;
            deviceBindingRequired = data.deviceBindingRequired;
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

  CardBuyCreateRequestModel getModelForCardBuyReq({
    required PaymentMethodCategory category,
    required String pAmount,
    required String bAsset,
    required String pAsset,
  }) {
    switch (category) {
      case PaymentMethodCategory.cards:
        return CardBuyCreateRequestModel(
          paymentMethod: convertMethodToCirclePaymentMethod(category),
          paymentAmount: Decimal.parse(pAmount),
          buyAmount: Decimal.parse(pAmount) * price,
          buyAsset: bAsset,
          paymentAsset: pAsset,
          cardPaymentData: CirclePaymentDataModel(cardId: card!.id),
          buyFixed: false,
        );
      case PaymentMethodCategory.account:
        return CardBuyCreateRequestModel(
          paymentMethod: convertMethodToCirclePaymentMethod(category),
          paymentAmount: Decimal.parse(pAmount),
          buyAmount: Decimal.parse(pAmount) * price,
          buyAsset: bAsset,
          paymentAsset: pAsset,
          ibanPaymentData: IbanPaymentPreview(accountId: account?.accountId ?? ''),
          buyFixed: false,
        );
      default:
        return CardBuyCreateRequestModel(
          paymentMethod: convertMethodToCirclePaymentMethod(category),
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
      paymentMethodName: category == PaymentMethodCategory.cards ? 'card' : 'account',
      paymentMethodCurrency: depositFeeCurrency.symbol,
    );

    if (sRouter.currentPath != '/buy_flow_confirmation') {
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
      await getActualData();

      price = await getConversionPrice(
            ConversionPriceInput(
              baseAssetSymbol: buyAsset!,
              quotedAssetSymbol: paymentAsset!,
            ),
          ) ??
          Decimal.zero;

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
      sourceCurrency: depositFeeCurrency.symbol,
      destinationCurrency: buyAssetSymbol ?? '',
      sourceAmount: '$paymentAmount',
      destinationAmount: '$buyAmount',
      exchangeRate: '1 $buyAssetSymbol = ${volumeFormat(
        symbol: depositFeeCurrency.symbol,
        accuracy: buyCurrency.accuracy,
        decimal: rate ?? Decimal.zero,
      )}',
      paymentFee: '$depositFeeAmount',
      firstTimeBuy: '$firstBuy',
      paymentMethodType: category.name,
      paymentMethodName: category == PaymentMethodCategory.cards ? 'card' : 'account',
      paymentMethodCurrency: depositFeeCurrency.symbol,
    );

    unawaited(_setIsChecked());
    unawaited(_saveLastPaymentMethod());

    if (category == PaymentMethodCategory.cards) {
      sAnalytics.newBuyEnterCvvView(firstTimeBuy: '$firstBuy');

      showBankCardCvvBottomSheet(
        context: sRouter.navigatorKey.currentContext!,
        header: '${intl.previewBuyWithCircle_enter} CVV '
            '${intl.previewBuyWithCircle_for} \n'
            '${card!.cardLabel}'
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
    } else if (category == PaymentMethodCategory.account) {
      await _requestPaymentAccaunt();
    }
  }

  @action
  Future<void> _requestPaymentAccaunt() async {
    var pin = '';
    try {
      termiteUpdate();

      await sRouter.push(
        PinScreenRoute(
          union: const Change(),
          isChangePhone: true,
          onChangePhone: (String newPin) async {
            pin = newPin;
            await sRouter.pop();
          },
        ),
      );

      if (pin == '') return;

      showProcessing = true;
      wasAction = true;

      sAnalytics.newBuyProcessingView(
        firstTimeBuy: '$firstBuy',
        paymentMethodType: category.name,
        paymentMethodName: category == PaymentMethodCategory.cards ? 'card' : 'account',
        paymentMethodCurrency: depositFeeCurrency.symbol,
      );
      if (deviceBindingRequired) {
        var continueBuying = false;

        final formatedAmaunt =
            volumeFormat(symbol: payAsset, accuracy: payCurrency.accuracy, decimal: Decimal.parse(payAmount));
        await Future.delayed(const Duration(milliseconds: 500));
        await sShowAlertPopup(
          sRouter.navigatorKey.currentContext!,
          primaryText: '',
          secondaryText:
              '${intl.binding_phone_dialog_first_part} $formatedAmaunt ${intl.binding_phone_dialog_second_part} $simpleCompanyName',
          primaryButtonName: intl.binding_phone_dialog_confirm,
          secondaryButtonName: intl.binding_phone_dialog_cancel,
          image: Image.asset(
            infoLightAsset,
            width: 80,
            height: 80,
            package: 'simple_kit',
          ),
          onPrimaryButtonTap: () {
            continueBuying = true;
            sRouter.pop();
          },
          onSecondaryButtonTap: () {
            continueBuying = false;
            sRouter.pop();
          },
        );

        if (!continueBuying) return;

        final phoneNumber = countryCodeByUserRegister();
        var isVerifaierd = false;
        await sRouter.push(
          PhoneVerificationRouter(
            args: PhoneVerificationArgs(
              isDeviceBinding: true,
              phoneNumber: sUserInfo.phone,
              activeDialCode: phoneNumber,
              onVerified: () {
                isVerifaierd = true;
                sRouter.pop();
              },
            ),
          ),
        );
        if (!isVerifaierd) return;
      }

      loader.startLoadingImmediately();

      late DC<ServerRejectException, dynamic> resp;

      if (account?.accountId == 'clearjuction_account') {
        final model = ExecuteQuoteRequestModel(
          operationId: paymentId,
          price: price,
          fromAssetSymbol: paymentAsset!,
          toAssetSymbol: buyAsset!,
          fromAssetAmount: paymentAmount,
          toAssetAmount: buyAmount,
        );

        resp = await sNetwork.getWalletModule().postExecuteQuote(model);
      } else {
        final model = CardBuyExecuteRequestModel(
          paymentId: paymentId,
          paymentMethod: convertMethodToCirclePaymentMethod(category),
          ibanPaymentData: IbanPaymentData(
            accountId: account?.accountId,
            pin: pin,
          ),
        );

        resp = await sNetwork.getWalletModule().postCardBuyExecute(
              model,
              cancelToken: cancelToken,
            );
      }

      if (resp.hasError) {
        await _showFailureScreen(resp.error?.cause ?? '');

        return;
      }

      if (sRouter.currentPath != '/buy_flow_confirmation') {
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

      final model = CardBuyExecuteRequestModel(
        paymentId: paymentId,
        paymentMethod: convertMethodToCirclePaymentMethod(category),
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
        paymentMethodName: category == PaymentMethodCategory.cards ? 'card' : 'account',
        paymentMethodCurrency: depositFeeCurrency.symbol,
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
            paymentMethodName: category == PaymentMethodCategory.cards ? 'card' : 'account',
            paymentMethodCurrency: depositFeeCurrency.symbol,
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
            paymentMethodName: category == PaymentMethodCategory.cards ? 'card' : 'account',
            paymentMethodCurrency: depositFeeCurrency.symbol,
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
                sAnalytics.paymentWevViewClose(
                  paymentMethodType: category.name,
                  paymentMethodName: category == PaymentMethodCategory.cards ? 'card' : 'account',
                  paymentMethodCurrency: depositFeeCurrency.symbol,
                );

                if (payment != null) {
                  sRouter.pop();
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
    sAnalytics.newBuySuccessView(
      firstTimeBuy: '$firstBuy',
      paymentMethodType: category.name,
      paymentMethodName: category == PaymentMethodCategory.cards ? 'card' : 'account',
      paymentMethodCurrency: depositFeeCurrency.symbol,
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
                MyWalletsRouter(),
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

  @computed
  String get getProcessingText {
    switch (category) {
      case PaymentMethodCategory.cards:
        return '';
      case PaymentMethodCategory.local:
        return intl.buy_confirmation_local_p2p_processing_text;

      default:
        return '';
    }
  }

  void skipProcessing() {
    sAnalytics.newBuyTapCloseProcessing(
      firstTimeBuy: '$firstBuy',
      paymentMethodType: category.name,
      paymentMethodName: category == PaymentMethodCategory.cards ? 'card' : 'account',
      paymentMethodCurrency: depositFeeCurrency.symbol,
    );
  }

  Future<void> _saveLastPaymentMethod() async {
    try {
      final storage = sLocalStorageService;

      switch (category) {
        case PaymentMethodCategory.cards:
          await storage.setString(
            bankLastMethodId,
            card?.id ?? '',
          );
          break;

        default:
      }
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'BuyConfirmationStore',
            message: e.toString(),
          );
    }
  }
}

CirclePaymentMethod convertMethodToCirclePaymentMethod(PaymentMethodCategory method) {
  switch (method) {
    case PaymentMethodCategory.cards:
      return CirclePaymentMethod.bankCard;
    case PaymentMethodCategory.account:
      return CirclePaymentMethod.ibanTransferUnlimint;
    default:
      return CirclePaymentMethod.bankCard;
  }
}
