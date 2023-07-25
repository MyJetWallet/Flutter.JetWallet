import 'dart:async';
import 'dart:convert';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/key_value_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_unlimint_input.dart';
import 'package:jetwallet/utils/constants.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/asset_payment_methods.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_create/card_buy_create_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_execute/card_buy_execute_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_info/card_buy_info_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/card_buy_info/card_buy_info_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/key_value/key_value_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/unlimint/add_unlimint_card_request_model.dart';

import '../../../utils/formatting/base/volume_format.dart';

part 'preview_buy_with_unlimint_store.g.dart';

class PreviewBuyWithUnlimitStore extends _PreviewBuyWithUnlimitStoreBase
    with _$PreviewBuyWithUnlimitStore {
  PreviewBuyWithUnlimitStore(PreviewBuyWithUnlimintInput input) : super(input);

  static _PreviewBuyWithUnlimitStoreBase of(BuildContext context) =>
      Provider.of<PreviewBuyWithUnlimitStore>(context, listen: false);
}

abstract class _PreviewBuyWithUnlimitStoreBase with Store {
  _PreviewBuyWithUnlimitStoreBase(this.input) {
    _initState();
    _requestPreview();
  }

  final PreviewBuyWithUnlimintInput input;

  static final _logger = Logger('PreviewBuyWithUnlimintStore');

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

    final model = CardBuyCreateRequestModel(
      paymentMethod: CirclePaymentMethod.unlimint,
      paymentAmount: amountToPay!,
      buyAsset: input.currency.symbol,
      paymentAsset: input.currencyPayment.symbol,
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
  Future<void> onConfirm() async {
    _logger.log(notifier, 'onConfirm');
    final storage = sLocalStorageService;
    await storage.setString(checkedUnlimint, 'true');
    final buyMethod = input.currency.buyMethods
        .where(
          (element) => element.id == PaymentMethodType.unlimintCard,
        )
        .toList();

    await _createPayment();
  }

  @action
  Future<void> _createPayment() async {
    _logger.log(notifier, '_createPayment');

    loader.startLoadingImmediately();
    final buyMethod = input.currency.buyMethods
        .where(
          (element) => element.id == PaymentMethodType.unlimintCard,
        )
        .toList();

    await _requestPayment(() async {
      await _requestPaymentInfo(
        (url, onSuccess, onCancel, onFailed, paymentId) {
          isChecked = true;
          sRouter.push(
            Circle3dSecureWebViewRouter(
              title: intl.previewBuyWithCircle_paymentVerification,
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
      await sLocalStorageService.setString(lastUsedCard, input.card?.id ?? '');
      await getIt.get<KeyValuesService>().addToKeyValue(
            KeyValueRequestModel(
              keys: [
                KeyValueResponseModel(
                  key: lastUsedPaymentMethodKey,
                  value: jsonEncode('unlimintCard'),
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
      final model = CardBuyExecuteRequestModel(
        paymentId: paymentId,
        paymentMethod: CirclePaymentMethod.unlimint,
        unlimintPaymentData: UnlimintPaymentDataExecuteModel(
          cardId: input.card?.id,
        ),
      );

      final resp = await sNetwork.getWalletModule().postCardBuyExecute(model);

      if (resp.hasError) {
        _logger.log(stateFlow, '_requestPayment', resp.error?.cause ?? '');

        unawaited(_showFailureScreen(resp.error?.cause ?? ''));

        return;
      }

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
    ) onAction,
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
            if (isWaitingSkipped) {
              return;
            }
            if (data.buyInfo != null) {
              buyAmount = data.buyInfo!.buyAmount;
            }
            unawaited(_showSuccessScreen());
          } else if (failed) {
            if (isWaitingSkipped) {
              return;
            }
            throw Exception();
          } else if (actionRequired) {
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
    final model = AddUnlimintCardRequestModel(
      buyPaymentId: paymentId,
    );
    var tapped = false;
    final buyMethod = input.currency.buyMethods
        .where(
          (element) => element.id == PaymentMethodType.bankCard,
        )
        .toList();

    return sRouter
        .push(
      SuccessScreenRouter(
        secondaryText: '${intl.successScreen_youBought} '
            '${volumeFormat(
          decimal: buyAmount ?? Decimal.zero,
          accuracy: input.currency.accuracy,
          symbol: input.currency.symbol,
        )}',
        time: input.card != null ? 3 : 5,
        showActionButton: input.card == null,
        buttonText: intl.previewBuyWithUmlimint_saveCard,
        showProgressBar: true,
        onActionButton: () async {
          tapped = true;
          final _ = await sNetwork.getWalletModule().postAddUnlimintCard(model);

          await sLocalStorageService.setString(
            lastUsedCard,
            _.data?.cardId ?? '',
          );

          navigateToRouter();

          unawaited(
            sRouter.push(
              const PaymentMethodsRouter(),
            ),
          );
        },
      ),
    )
        .then(
      (value) {
        if (!tapped) {
          sRouter.push(
            const HomeRouter(
              children: [
                PortfolioRouter(),
              ],
            ),
          );
        }
      },
    );
  }

  @action
  Future<void> _showFailureScreen(String error) {
    final buyMethod = input.currency.buyMethods
        .where(
          (element) => element.id == PaymentMethodType.bankCard,
        )
        .toList();

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
      final status = await storage.getValue(checkedUnlimint);
      if (status != null) {
        isChecked = true;
      }
    } catch (e) {
      _logger.log(notifier, '_isChecked');
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
