import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/key_value_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_circle_input.dart';
import 'package:jetwallet/features/currency_buy/ui/screens/preview_buy_with_circle/show_circle_cvv_bottom_sheet.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:openpgp/openpgp.dart';
import 'package:provider/provider.dart';
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

import '../../../utils/formatting/base/volume_format.dart';

part 'preview_buy_with_circle_store.g.dart';

class PreviewBuyWithCircleStore extends _PreviewBuyWithCircleStoreBase
    with _$PreviewBuyWithCircleStore {
  PreviewBuyWithCircleStore(PreviewBuyWithCircleInput input) : super(input);

  static _PreviewBuyWithCircleStoreBase of(BuildContext context) =>
      Provider.of<PreviewBuyWithCircleStore>(context, listen: false);
}

abstract class _PreviewBuyWithCircleStoreBase with Store {
  _PreviewBuyWithCircleStoreBase(this.input) {
    _initState();
    _requestPreview();
    _requestCards();
    _isChecked();
  }

  final PreviewBuyWithCircleInput input;

  static final _logger = Logger('PreviewBuyWithCircleStore');

  @observable
  bool wasPending = false;

  @observable
  bool isPending = false;

  @observable
  bool failureShowed = false;

  @observable
  CircleCard? card;

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
  StackLoaderStore loader = StackLoaderStore();

  @action
  void _initState() {
    amountToGet = Decimal.parse(input.amount);
    amountToPay = Decimal.parse(input.amount);
    card = input.card;
  }

  @action
  Future<void> _requestPreview() async {
    loader.startLoadingImmediately();

    final model = CardBuyCreateRequestModel(
      paymentMethod: CirclePaymentMethod.circle,
      paymentAmount: amountToPay!,
      buyAsset: input.currency.symbol,
      paymentAsset: input.currencyPayment.symbol,
      circlePaymentData: CirclePaymentDataModel(
        cardId: card!.id,
      ),
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
          sAnalytics.newBuyTapContinue(
            sourceCurrency: input.currencyPayment.symbol,
            destinationCurrency: input.currency.symbol,
            paymentMethod: 'Circle card',
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
    }
  }

  @action
  void onConfirm() {
    _logger.log(notifier, 'onConfirm');
    final storage = sLocalStorageService;

    storage.setString(checkedCircle, 'true');
    final buyMethod = input.currency.buyMethods
        .where(
          (element) => element.id == PaymentMethodType.circleCard,
        )
        .toList();
    sAnalytics.newBuyTapConfirm(
      sourceCurrency: input.currencyPayment.symbol,
      destinationCurrency: input.currency.symbol,
      paymentMethod: 'Circle card',
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

    if (cvvEnabled) {
      showCircleCvvBottomSheet(
        context: sRouter.navigatorKey.currentContext!,
        header: '${intl.previewBuyWithCircle_enter} CVV '
            '${intl.previewBuyWithCircle_for} '
            '${card?.network.name} •••• ${card?.last4}',
        onCompleted: (_cvv) {
          sRouter.pop();
          cvv = _cvv;
          _createPayment();
        },
        input: input,
      );
    } else {
      _createPayment();
    }
  }

  @action
  Future<void> _createPayment() async {
    _logger.log(notifier, '_createPayment');

    loader.startLoadingImmediately();

    await _requestPayment(() async {
      await _requestPaymentInfo(
        (url, onSuccess, paymentId) {
          sRouter.push(
            Circle3dSecureWebViewRouter(
              title: intl.previewBuyWithCircle_paymentVerification,
              url: url,
              amount: input.amount,
              asset: currencySymbol,
              onSuccess: onSuccess,
              onFailed: _showFailureScreen,
              onCancel: (value) {},
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
  Future<void> _requestCards() async {
    _logger.log(notifier, '_requestCards');
    try {
      final response = await sNetwork.getWalletModule().getAllCards();

      response.pick(
        onData: (data) {
          if (data.cards.isNotEmpty) {
            final actualCard = data.cards
                .where(
                  (element) => element.id == card?.id,
                )
                .toList();
            if (actualCard.isNotEmpty) {
              isPending = actualCard[0].status == CircleCardStatus.pending;
              wasPending = actualCard[0].status == CircleCardStatus.pending;
            }
          }
        },
        onError: (error) async {
          await Future.delayed(const Duration(seconds: 5));
          await _requestCards();
        },
      );
    } catch (e) {
      await Future.delayed(const Duration(seconds: 5));
      await _requestCards();
    }
  }

  @action
  Future<void> _isChecked() async {
    try {
      final storage = sLocalStorageService;
      final status = await storage.getValue(checkedCircle);
      if (status != null) {
        isChecked = true;
      }
    } catch (e) {
      _logger.log(notifier, '_isChecked');
    }
  }

  @action
  Future<void> setLastUsedPaymentMethod() async {
    _logger.log(notifier, 'setLastUsedPaymentMethod');

    try {
      await sLocalStorageService.setString(lastUsedCard, input.card.id);
      await getIt.get<KeyValuesService>().addToKeyValue(
            KeyValueRequestModel(
              keys: [
                KeyValueResponseModel(
                  key: lastUsedPaymentMethodKey,
                  value: jsonEncode('circleCard'),
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
      final response = await sNetwork.getWalletModule().getEncryptionKey();

      response.pick(
        onData: (data) async {
          final base64Decoded = base64Decode(data.encryptionKey);
          final utf8Decoded = utf8.decode(base64Decoded);
          final encrypted = await OpenPGP.encrypt(
            cvv.isNotEmpty ? '{"cvv":"$cvv"}' : '{}',
            utf8Decoded,
          );
          final utf8Encoded = utf8.encode(encrypted);
          final base64Encoded = base64Encode(utf8Encoded);

          final model = CardBuyExecuteRequestModel(
            paymentId: paymentId,
            paymentMethod: CirclePaymentMethod.circle,
            circlePaymentData: CirclePaymentDataExecuteModel(
              cardId: card!.id,
              keyId: data.keyId,
              encryptedData: base64Encoded,
            ),
          );

          final _ = await sNetwork.getWalletModule().postCardBuyExecute(model);

          onSuccess();
        },
        onError: (error) {
          _logger.log(stateFlow, '_requestPayment', error.cause);

          _showFailureScreen(error.cause);
        },
      );
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
    Function(String, Function(String, String), String) onAction,
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
            await Future.delayed(const Duration(seconds: 1));
            await _requestPaymentInfo(onAction, lastAction);
          } else if (complete) {
            if (data.buyInfo != null) {
              buyAmount = data.buyInfo!.buyAmount;
            }
            unawaited(_showSuccessScreen());
          } else if (failed) {
            throw Exception();
          } else if (actionRequired) {
            onAction(
              data.clientAction!.checkoutUrl ?? '',
              (payment, lastAction) {
                Navigator.pop(sRouter.navigatorKey.currentContext!);

                paymentId = payment;
                loader.startLoadingImmediately();
                _requestPaymentInfo(onAction, lastAction);
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
    final buyMethod = input.currency.buyMethods
        .where(
          (element) => element.id == PaymentMethodType.bankCard,
        )
        .toList();
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
          ),
        )
        .then(
          (value) => sRouter.push(
            const HomeRouter(
              children: [
                PortfolioRouter(),
              ],
            ),
          ),
        );
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
  Future<void> _showFailureScreen(String error) {
    final buyMethod = input.currency.buyMethods
        .where(
          (element) => element.id == PaymentMethodType.bankCard,
        )
        .toList();
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
  void checkSetter() {
    isChecked = !isChecked;
  }

  @action
  void setWasPending({required bool value}) {
    wasPending = value;
  }

  @action
  void setIsPending({required bool pending}) {
    isPending = pending;
  }

  @action
  void setFailureShowed({required bool fShowed}) {
    failureShowed = fShowed;
  }

  @action
  void showFailure() {
    if (!failureShowed) {
      setFailureShowed(fShowed: true);

      sRouter.push(
        FailureScreenRouter(
          primaryText: intl.previewBuyWithCircle_failure,
          secondaryText: intl.previewBuyWithCircle_failureDescription,
          primaryButtonName: intl.previewBuyWithCircle_failureAnotherCard,
          onPrimaryButtonTap: () {
            sRouter.navigate(
              AddCircleCardRouter(
                onCardAdded: (card) {
                  sRouter.pop();
                  sRouter.pop();
                  sRouter.pop();
                },
              ),
            );
          },
          secondaryButtonName: intl.previewBuyWithCircle_failureCancel,
          onSecondaryButtonTap: () {
            sRouter.pop();
            sRouter.pop();
            sRouter.pop();
          },
        ),
      );
    }
  }
}
