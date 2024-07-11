// ignore_for_file: use_setters_to_change_properties

import 'dart:async';
import 'dart:developer';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/convert/model/preview_convert_input.dart';
import 'package:jetwallet/features/convert/model/preview_convert_union.dart';
import 'package:jetwallet/utils/helpers/rate_up/show_rate_up_popup.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/widgets/quote_updated_dialog.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/actions/confirm_action_timer/simple_timer_animation_countdown.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/swap_execute_quote/execute_quote_request_model.dart';

part 'preview_convert_store.g.dart';

class PreviewConvertStore extends _PreviewConvertStoreBase with _$PreviewConvertStore {
  PreviewConvertStore(super.input);

  static PreviewConvertStore of(BuildContext context) => Provider.of<PreviewConvertStore>(context, listen: false);
}

abstract class _PreviewConvertStoreBase with Store {
  _PreviewConvertStoreBase(this.input) {
    log(input.toString());

    _updateFrom(input);
    requestQuote();
  }

  final PreviewConvertInput input;

  Timer _timer = Timer(Duration.zero, () {});

  static final _logger = Logger('PreviewConvertStore');

  @observable
  String? operationId;

  @observable
  Decimal? price;

  @observable
  String? fromAssetSymbol;

  @observable
  String? toAssetSymbol;

  @observable
  Decimal? fromAssetAmount;

  @observable
  Decimal? toAssetAmount;

  @observable
  String? feeAsset;

  @observable
  Decimal? feeAmount;

  @observable
  Decimal? feePercent;

  // Will be initialzied on initState of the parent widget
  AnimationController? timerAnimation;

  // [true] when requestQuote() takes too long
  @observable
  bool connectingToServer = false;

  @observable
  PreviewConvertUnion union = const QuoteLoading();

  @observable
  int timer = 0;

  @computed
  String get previewHeader {
    return '${intl.previewConvert_confirmExchange}\n'
        '${input.fromCurrency.symbol} ${intl.to} ${input.toCurrency.symbol}';
  }

  @action
  void _updateFrom(PreviewConvertInput input) {
    fromAssetAmount = Decimal.parse(input.fromAmount);
    toAssetAmount = Decimal.parse(input.toAmount);
    fromAssetSymbol = input.fromCurrency.symbol;
    toAssetSymbol = input.toCurrency.symbol;
  }

  @action
  Future<void> requestQuote() async {
    _logger.log(notifier, 'requestQuote');

    //union = const QuoteLoading();
    union = const QuoteLoading();

    final model = GetQuoteRequestModel(
      fromAssetAmount: input.toAssetEnabled ? null : fromAssetAmount,
      fromAssetSymbol: fromAssetSymbol!,
      toAssetSymbol: toAssetSymbol!,
      toAssetAmount: input.toAssetEnabled ? toAssetAmount : null,
      isFromFixed: !input.toAssetEnabled,
    );

    try {
      final response = await sNetwork.getWalletModule().postGetQuote(model);

      response.pick(
        onData: (data) {
          operationId = data.operationId;
          price = data.price;
          fromAssetSymbol = data.fromAssetSymbol;
          toAssetSymbol = data.toAssetSymbol;
          fromAssetAmount = data.fromAssetAmount;
          toAssetAmount = data.toAssetAmount;
          union = const QuoteSuccess();

          connectingToServer = false;

          feeAsset = data.feeAsset;
          feeAmount = data.feeAmount;
          feePercent = data.feePercent;

          if (data.expirationTime >= 0) {
            _refreshTimerAnimation(data.expirationTime);
            _refreshTimer(data.expirationTime);
          }
        },
        onError: (error) {
          _logger.log(stateFlow, 'requestQuote', error.cause);

          _showFailureScreen(error);
        },
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'requestQuote', error.cause);

      _showFailureScreen(error);
    } catch (error) {
      _logger.log(stateFlow, 'requestQuote', error);

      union = const QuoteLoading();
      connectingToServer = true;

      _refreshTimer(quoteRetryInterval);
    }
  }

  bool waitQuote = false;

  @action
  Future<void> executeQuote() async {
    if (waitQuote) return;

    waitQuote = true;

    _logger.log(notifier, 'executeQuote');

    //union = const ExecuteLoading();
    union = const QuoteSuccess();

    try {
      final model = ExecuteQuoteRequestModel(
        operationId: operationId!,
        price: price!,
        fromAssetSymbol: fromAssetSymbol!,
        toAssetSymbol: toAssetSymbol!,
        fromAssetAmount: fromAssetAmount,
        toAssetAmount: toAssetAmount,
        isFromFixed: !input.toAssetEnabled,
      );

      final response = await sNetwork.getWalletModule().postExecuteQuote(model);

      response.pick(
        onData: (data) {
          waitQuote = false;

          if (data.isExecuted) {
            _timer.cancel();
            _showSuccessScreen();
          } else {
            union = const QuoteSuccess();

            _timer.cancel();

            showQuoteUpdatedDialog(
              context: sRouter.navigatorKey.currentContext!,
              onPressed: () => requestQuote(),
            );
          }
        },
        onError: (error) {
          _logger.log(stateFlow, 'executeQuote', error.cause);

          _timer.cancel();
          _showFailureScreen(error);
          waitQuote = false;
        },
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'executeQuote', error.cause);

      _timer.cancel();
      _showFailureScreen(error);
      waitQuote = false;
    } catch (error) {
      _logger.log(stateFlow, 'executeQuote', error);

      _timer.cancel();
      _showNoResponseScreen();
      waitQuote = false;
    }

    waitQuote = false;
  }

  @action
  void cancelTimer() {
    _logger.log(notifier, 'cancelTimer');

    _timer.cancel();
  }

  /// Will be triggered during initState of the parent widget
  @action
  void updateTimerAnimation(AnimationController controller) {
    timerAnimation = controller;
  }

  /// Will be triggered only when timerAnimation is not Null
  @action
  void _refreshTimerAnimation(int duration) {
    timerAnimation!.duration = Duration(seconds: duration);
    timerAnimation!.countdown();
  }

  @action
  void _refreshTimer(int initial) {
    _timer.cancel();

    timer = initial;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (tick) {
        if (timer == 0) {
          tick.cancel();
          requestQuote();
        } else {
          timer = timer - 1;
        }
      },
    );
  }

  @action
  void _showSuccessScreen() {
    sRouter
        .push(
      SuccessScreenRouter(
        secondaryText: intl.previewConvert_orderProcessing,
      ),
    )
        .then((value) {
      sRouter.popUntilRoot();
      shopRateUpPopup(sRouter.navigatorKey.currentContext!);
    });
  }

  @action
  void _showNoResponseScreen() {
    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.showNoResponseScreen_text,
        secondaryText: intl.showNoResponseScreen_text2,
      ),
    );
  }

  @action
  void _showFailureScreen(ServerRejectException error) {
    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.previewConvert_failure,
        secondaryText: error.cause,
        secondaryButtonName: intl.previewConvert_editOrder,
        onSecondaryButtonTap: () {
          sRouter.removeUntil(
            (route) => route.name == ConvertRouter.name,
          );
        },
      ),
    );
  }

  @action
  void dispose() {
    _timer.cancel();
  }
}
