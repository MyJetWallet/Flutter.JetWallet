import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/key_value_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_bank_card_input.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/show_bank_card_cvv_bottom_sheet.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/formatting/base/volume_format.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:rsa_encrypt/rsa_encrypt.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_create/card_buy_create_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_execute/card_buy_execute_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_info/card_buy_info_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_info/card_buy_info_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/circle_card.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_response_model.dart';

import '../../../core/services/signal_r/signal_r_service_new.dart';

part 'preview_buy_with_bank_card_store.g.dart';

class PreviewBuyWithBankCardStore extends _PreviewBuyWithBankCardStoreBase
    with _$PreviewBuyWithBankCardStore {
  PreviewBuyWithBankCardStore(
    PreviewBuyWithBankCardInput input,
    bool sendPreview,
  ) : super(
          input,
          sendPreview,
        );

  static _PreviewBuyWithBankCardStoreBase of(BuildContext context) =>
      Provider.of<PreviewBuyWithBankCardStore>(context, listen: false);
}

abstract class _PreviewBuyWithBankCardStoreBase with Store {
  _PreviewBuyWithBankCardStoreBase(
    this.input,
    this.sendPreview,
  ) {
    _initState();
    if (sendPreview) {
      _requestPreview();
    }
  }

  final PreviewBuyWithBankCardInput input;
  final bool sendPreview;

  static final _logger = Logger('PreviewBuyWithBankCardStore');

  @observable
  Decimal? amountToGet;

  @observable
  Decimal? amountToPay;

  @observable
  Decimal? feeAmount;

  @observable
  Decimal? feePercentage;

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
  Decimal? depositFeeAmountMax;

  @observable
  Decimal? depositFeePerc;

  @observable
  String? tradeFeeAsset;

  @observable
  Decimal? rate;

  @observable
  String paymentId = '';

  @observable
  String cvv = '';

  @observable
  String currencySymbol = '';

  @observable
  bool isChecked = false;

  @observable
  bool wasAction = false;

  @observable
  bool isWaitingSkipped = false;

  @observable
  StackLoaderStore loader = StackLoaderStore();

  @action
  void _initState() {
    amountToGet = Decimal.parse(input.amount);
    amountToPay = Decimal.parse(input.amount);
  }

  @action
  Future<void> _requestPreview() async {
    loader.startLoadingImmediately();
    final cardData = CirclePaymentDataModel(cardId: input.cardId ?? '');

    final model = CardBuyCreateRequestModel(
      paymentMethod: CirclePaymentMethod.bankCard,
      paymentAmount: amountToPay!,
      buyAsset: input.currency.symbol,
      paymentAsset: input.currencyPayment.symbol,
      cardPaymentData: cardData,
    );

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
          depositFeeAmountMax = data.depositFeeAmountMax;
          depositFeePerc = data.depositFeePerc;

          sAnalytics.newBuyTapContinue(
            sourceCurrency: input.currencyPayment.symbol,
            destinationCurrency: input.currency.symbol,
            paymentMethod: 'Bank card',
            sourceAmount: '$paymentAmount',
            destinationAmount: '$buyAmount',
            quickAmount: input.quickAmount,
          );
        },
        onError: (error) {
          _logger.log(stateFlow, 'requestPreview', error.cause);

          _showFailureScreen(error.cause);
        },
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'requestPreview', error.cause);

      unawaited(_showFailureScreen(error.cause));
    } catch (error) {
      _logger.log(stateFlow, 'requestPreview', error);

      unawaited(_showFailureScreen(intl.something_went_wrong));
    } finally {
      loader.finishLoading();

      Timer(const Duration(milliseconds: 500), () {
        _isChecked();
      });
    }
  }

  @action
  void onConfirm() {
    _logger.log(notifier, 'onConfirm');
    final storage = sLocalStorageService;
    storage.setString(checkedBankCard, 'true');
    final buyMethod = input.currency.buyMethods.where(
      (element) => element.id == PaymentMethodType.bankCard,
    ).toList();
    sAnalytics.newBuyTapConfirm(
      sourceCurrency: input.currencyPayment.symbol,
      destinationCurrency: input.currency.symbol,
      paymentMethod: 'Bank card',
      sourceAmount: '$paymentAmount',
      destinationAmount: '$buyAmount',
      exchangeRate: '1 ${input.currency.symbol} = ${volumeFormat(
        prefix: input.currencyPayment.prefixSymbol,
        symbol: input.currencyPayment.symbol,
        accuracy: input.currencyPayment.accuracy,
        decimal: rate ?? Decimal.zero,
      )}',
      paymentFee: '$depositFeeAmount',
      firstTimeBuy: '${!(buyMethod.isNotEmpty && buyMethod[0].termsAccepted)}',
    );
    sAnalytics.newBuyEnterCvvView(
      firstTimeBuy: '${!(buyMethod.isNotEmpty && buyMethod[0].termsAccepted)}',
    );

    final uAC = sSignalRModules.cards.cardInfos.where(
          (element) => element.integration == IntegrationType.unlimintAlt,
    ).toList();
    final activeCard = uAC.where((element) => element.id == input.cardId)
        .toList();

    showBankCardCvvBottomSheet(
      context: sRouter.navigatorKey.currentContext!,
      header: '${intl.previewBuyWithCircle_enter} CVV '
          '${intl.previewBuyWithCircle_for} '
          '${activeCard.isNotEmpty ? activeCard[0].network : ''}'
          ' •••• ${input.cardNumber != null ? input.cardNumber?.substring((input.cardNumber?.length ?? 4) - 4) : ''}',
      onCompleted: (cvvNew) {
        cvv = cvvNew;
        sRouter.pop();
        _createPayment();
      },
      input: input,
    );
  }

  @action
  Future<void> _createPayment() async {
    _logger.log(notifier, '_createPayment');

    loader.startLoadingImmediately();
    final buyMethod = input.currency.buyMethods.where(
          (element) => element.id == PaymentMethodType.bankCard,
    ).toList();
    sAnalytics.newBuyProcessingView(
      firstTimeBuy: '${!(buyMethod.isNotEmpty && buyMethod[0].termsAccepted)}',
    );

    await _requestPayment(() async {
      await _requestPaymentInfo(
        (url, onSuccess, onCancel, onFailed, paymentId) {
          isChecked = true;
          sRouter.push(
            Circle3dSecureWebViewRouter(
              url: url,
              asset: currencySymbol,
              amount: input.amount,
              onSuccess: onSuccess,
              onFailed: onFailed,
              onCancel: onCancel,
              paymentId: paymentId,
            ),
          );

          loader.finishLoadingImmediately();
        },
        '',
      );
    });
    await setLastUsedPaymentMethod();
  }

  @action
  Future<void> setLastUsedPaymentMethod() async {
    _logger.log(notifier, 'setLastUsedPaymentMethod');

    try {
      await sLocalStorageService.setString(lastUsedCard, input.cardId);
      await getIt.get<KeyValuesService>().addToKeyValue(
            KeyValueRequestModel(
              keys: [
                KeyValueResponseModel(
                  key: lastUsedPaymentMethodKey,
                  value: jsonEncode('bankCard'),
                ),
              ],
            ),
          );
    } catch (e) {
      _logger.log(stateFlow, 'setLastUsedPaymentMethod', e);
    }
  }

  @action
  Future<void> _requestPayment(void Function() onSuccess) async {
    _logger.log(notifier, '_requestPayment');

    try {
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
        paymentMethod: CirclePaymentMethod.bankCard,
        cardPaymentData: BankCardPaymentDataExecuteModel(
          cardId: input.cardId ?? '',
          encKeyId: response.data?.data.keyId,
          encData: base64EncodedCvv,
        ),
      );

      final _ = await sNetwork.getWalletModule().postCardBuyExecute(model);

      onSuccess();
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, '_requestPayment', error.cause);


      unawaited(_showFailureScreen(error.cause));
    } catch (error) {
      _logger.log(stateFlow, '_requestPayment', error);

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
    )
        onAction,
    String lastAction,
  ) async {
    _logger.log(notifier, '_requestPaymentInfo');
    try {
      final model = CardBuyInfoRequestModel(
        paymentId: paymentId,
      );

      final response = await sNetwork.getWalletModule().postCardBuyInfo(model);

      response.pick(
        onData: (data) async {
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
            unawaited(_showSuccessScreen());
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
                wasAction = true;

                loader.startLoadingImmediately();
                _requestPaymentInfo(onAction, lastAction);
              },
              (payment) {
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
          _logger.log(stateFlow, '_requestPaymentInfo', error.cause);

          _showFailureScreen(error.cause);
        },
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, '_requestPaymentInfo', error.cause);

      unawaited(_showFailureScreen(error.cause));
    } catch (error) {
      _logger.log(stateFlow, '_requestPaymentInfo', error);

      unawaited(_showFailureScreen(intl.something_went_wrong));
    }
  }

  @action
  Future<void> _showSuccessScreen() {
    final buyMethod = input.currency.buyMethods.where(
          (element) => element.id == PaymentMethodType.bankCard,
    ).toList();
    sAnalytics.newBuySuccessView(
      firstTimeBuy: '${!(buyMethod.isNotEmpty && buyMethod[0].termsAccepted)}',
    );

    return sRouter
        .push(
          SuccessScreenRouter(
            secondaryText: '${intl.successScreen_youBought} '
                '${volumeFormat(
              decimal: buyAmount ?? Decimal.zero,
              accuracy: input.currency.accuracy,
              symbol: input.currency.symbol,
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
  Future<void> _showFailureScreen(String error) {
    final buyMethod = input.currency.buyMethods.where(
          (element) => element.id == PaymentMethodType.bankCard,
    ).toList();
    sAnalytics.newBuyFailedView(
      firstTimeBuy: '${!(buyMethod.isNotEmpty && buyMethod[0].termsAccepted)}',
      errorCode: error,
    );

    return sRouter.push(
      FailureScreenRouter(
        primaryText: intl.previewBuyWithAsset_failure,
        secondaryText: error,
        primaryButtonName: intl.previewBuyWithAsset_close,
        onPrimaryButtonTap: () {
          navigateToRouter();
        },
      ),
    );
  }

  @action
  Future<void> _isChecked() async {
    try {
      final storage = sLocalStorageService;
      final status = await storage.getValue(checkedBankCard);
      if (status != null) {
        isChecked = true;
      }
    } catch (e) {
      _logger.log(notifier, '_isChecked');
    }
  }

  @action
  Future<void> pasteCode() async {
    _logger.log(notifier, 'pasteCode');

    final data = await Clipboard.getData('text/plain');
    final code = data?.text?.trim() ?? '';

    if (code.length == 3) {
      try {
        int.parse(code);
        cvv = code;
        await sRouter.pop();
        await _createPayment();
      } catch (e) {
        return;
      }
    }
  }

  @action
  void checkSetter() {
    isChecked = !isChecked;
  }

  @action
  void skippedWaiting() {
    isWaitingSkipped = true;
  }
}
