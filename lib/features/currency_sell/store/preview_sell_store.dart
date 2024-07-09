import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/currency_sell/model/preview_sell_input.dart';
import 'package:jetwallet/features/currency_sell/model/preview_sell_union.dart';
import 'package:jetwallet/utils/helpers/rate_up/show_rate_up_popup.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/widgets/quote_updated_dialog.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/actions/confirm_action_timer/simple_timer_animation_countdown.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/swap_execute_quote/execute_quote_request_model.dart';

part 'preview_sell_store.g.dart';

class PreviewSellStore extends _PreviewSellStoreBase with _$PreviewSellStore {
  PreviewSellStore(super.input);

  static _PreviewSellStoreBase of(BuildContext context) => Provider.of<PreviewSellStore>(context, listen: false);
}

abstract class _PreviewSellStoreBase with Store {
  _PreviewSellStoreBase(this.input) {
    _updateFrom(input);
    requestQuote();
  }

  final PreviewSellInput input;

  static final _logger = Logger('PreviewBuyWithAssetStore');

  Timer _timer = Timer(Duration.zero, () {});

  final loader = StackLoaderStore();

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
  Decimal? feePercent;

  // Will be initialzied on initState of the parent widget
  AnimationController? timerAnimation;

  @observable
  bool connectingToServer = false;

  @observable
  PreviewSellUnion union = const QuoteLoading();

  @observable
  int timer = 0;

  @action
  void _updateFrom(PreviewSellInput input) {
    fromAssetAmount = Decimal.parse(input.amount);
    fromAssetSymbol = input.fromCurrency.symbol;
    toAssetSymbol = input.toCurrency.symbol;
  }

  @action
  Future<void> requestQuote() async {
    _logger.log(notifier, 'requestQuote');

    //union = const QuoteLoading();

    final model = GetQuoteRequestModel(
      fromAssetAmount: fromAssetAmount,
      fromAssetSymbol: fromAssetSymbol!,
      toAssetSymbol: toAssetSymbol!,
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
          feePercent = data.feePercent;

          _refreshTimerAnimation(data.expirationTime);
          _refreshTimer(data.expirationTime);
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

  @action
  Future<void> executeQuote() async {
    _logger.log(notifier, 'executeQuote');

    union = const ExecuteLoading();

    try {
      final model = ExecuteQuoteRequestModel(
        operationId: operationId!,
        price: price!,
        fromAssetSymbol: fromAssetSymbol!,
        toAssetSymbol: toAssetSymbol!,
        fromAssetAmount: fromAssetAmount,
        toAssetAmount: toAssetAmount,
      );

      final response = await sNetwork.getWalletModule().postExecuteQuote(model);

      response.pick(
        onData: (data) {
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
        },
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'executeQuote', error.cause);

      _timer.cancel();
      _showFailureScreen(error);
    } catch (error) {
      _logger.log(stateFlow, 'executeQuote', error);

      _timer.cancel();
      _showNoResponseScreen();
    }
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
        secondaryText: intl.previewSell_orderProcessing,
      ),
    )
        .then((value) {
      sRouter.navigate(
        const HomeRouter(
          children: [MyWalletsRouter()],
        ),
      );

      shopRateUpPopup(sRouter.navigatorKey.currentContext!);
    });
  }

  @action
  void _showNoResponseScreen() {
    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.showNoResponseScreen_text,
        secondaryText: intl.showNoResponseScreen_text2,
        primaryButtonName: intl.serverCode0_ok,
        onPrimaryButtonTap: () {
          sRouter.navigate(
            const HomeRouter(
              children: [MyWalletsRouter()],
            ),
          );
        },
      ),
    );
  }

  @action
  void _showFailureScreen(ServerRejectException error) {
    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.previewSell_failure,
        secondaryText: error.cause,
        secondaryButtonName: intl.previewSell_editOrder,
        onSecondaryButtonTap: () {
          Navigator.pop(sRouter.navigatorKey.currentContext!);
          Navigator.pop(sRouter.navigatorKey.currentContext!);
          sRouter.navigate(
            CurrencySellRouter(
              currency: input.fromCurrency,
            ),
          );
        },
        primaryButtonName: intl.previewSell_close,
        onPrimaryButtonTap: () => sRouter.popUntilRoot(),
      ),
    );
  }

  @computed
  String get previewHeader {
    return '${intl.previewSell_confirmSell}'
        ' ${input.fromCurrency.description}';
  }

  @action
  void dispose() {
    _timer.cancel();
  }
}
