import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';

import '../../../../../../../../service/services/swap/model/execute_quote/execute_quote_request_model.dart';
import '../../../../../../../../service/services/swap/model/get_quote/get_quote_request_model.dart';
import '../../../../../../../../shared/providers/service_providers.dart';
import '../../../../../../service/shared/models/server_reject_exception.dart';
import '../../../../../../shared/components/result_screens/failure_screen/failure_screen.dart';
import '../../../../../../shared/components/result_screens/success_screen/success_screen.dart';
import '../../../../../../shared/helpers/navigate_to_router.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../../screens/navigation/provider/navigation_stpod.dart';
import '../../../../components/quote_updated_dialog.dart';
import '../../../../helpers/are_balances_empty.dart';
import '../../../../providers/currencies_pod/currencies_pod.dart';
import '../../../recurring/helper/recurring_buys_operation_name.dart';
import '../../../recurring/view/components/recurring_success_screen.dart';
import '../../model/preview_buy_with_asset_input.dart';
import '../../view/curency_buy.dart';
import 'preview_buy_with_asset_state.dart';
import 'preview_buy_with_asset_union.dart';

class PreviewBuyWithAssetNotifier
    extends StateNotifier<PreviewBuyWithAssetState> {
  PreviewBuyWithAssetNotifier(
    this.input,
    this.read,
  ) : super(const PreviewBuyWithAssetState()) {
    _context = read(sNavigatorKeyPod).currentContext!;
    _updateFrom(input);
    requestQuote();
  }

  final Reader read;
  final PreviewBuyWithAssetInput input;

  Timer _timer = Timer(Duration.zero, () {});
  late BuildContext _context;

  static final _logger = Logger('PreviewBuyWithAssetNotifier');

  void _updateFrom(PreviewBuyWithAssetInput input) {
    state = state.copyWith(
      fromAssetAmount: Decimal.parse(input.amount),
      fromAssetSymbol: input.fromCurrency.symbol,
      toAssetSymbol: input.toCurrency.symbol,
      recurringType: input.recurringType,
    );
  }

  Future<void> requestQuote() async {
    _logger.log(notifier, 'requestQuote');

    state = state.copyWith(union: const QuoteLoading());

    final recurringBuy =
        state.recurringType == RecurringBuysType.oneTimePurchase
            ? null
            : RecurringBuyModel(
                scheduleType: state.recurringType,
              );

    final model = GetQuoteRequestModel(
      fromAssetAmount: state.fromAssetAmount,
      fromAssetSymbol: state.fromAssetSymbol!,
      toAssetSymbol: state.toAssetSymbol!,
      recurringBuy: recurringBuy,
    );

    try {
      final response = await read(swapServicePod).getQuote(model);

      state = state.copyWith(
        operationId: response.operationId,
        price: response.price,
        fromAssetSymbol: response.fromAssetSymbol,
        toAssetSymbol: response.toAssetSymbol,
        fromAssetAmount: response.fromAssetAmount,
        toAssetAmount: response.toAssetAmount,
        union: const QuoteSuccess(),
        connectingToServer: false,
        feePercent: response.feePercent,
        recurringBuyInfo: response.recurringBuyInfo,
      );

      _refreshTimerAnimation(response.expirationTime);
      _refreshTimer(response.expirationTime);
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'requestQuote', error.cause);

      _showFailureScreen(error);
    } catch (error) {
      _logger.log(stateFlow, 'requestQuote', error);

      state = state.copyWith(
        union: const QuoteLoading(),
        connectingToServer: true,
      );

      _refreshTimer(quoteRetryInterval);
    }
  }

  Future<void> executeQuote() async {
    _logger.log(notifier, 'executeQuote');

    state = state.copyWith(union: const ExecuteLoading());

    try {
      final model = ExecuteQuoteRequestModel(
        operationId: state.operationId!,
        price: state.price!,
        fromAssetSymbol: state.fromAssetSymbol!,
        toAssetSymbol: state.toAssetSymbol!,
        fromAssetAmount: state.fromAssetAmount,
        toAssetAmount: state.toAssetAmount,
        recurringBuyInfo: state.recurringBuyInfo,
      );

      final response = await read(swapServicePod).executeQuote(model);

      if (response.isExecuted) {
        _timer.cancel();
        _showSuccessScreen();
      } else {
        state = state.copyWith(union: const QuoteSuccess());
        _timer.cancel();
        if (!mounted) return;
        showQuoteUpdatedDialog(
          context: _context,
          onPressed: () => requestQuote(),
        );
      }
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

  void cancelTimer() {
    _logger.log(notifier, 'cancelTimer');

    _timer.cancel();
  }

  /// Will be triggered during initState of the parent widget
  void updateTimerAnimation(AnimationController controller) {
    state = state.copyWith(timerAnimation: controller);
  }

  /// Will be triggered only when timerAnimation is not Null
  void _refreshTimerAnimation(int duration) {
    state.timerAnimation!.duration = Duration(seconds: duration);
    state.timerAnimation!.countdown();
  }

  void _refreshTimer(int initial) {
    _timer.cancel();
    state = state.copyWith(timer: initial);

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (state.timer == 0) {
          timer.cancel();
          requestQuote();
        } else {
          state = state.copyWith(
            timer: state.timer - 1,
          );
        }
      },
    );
  }

  void _showSuccessScreen() {
    final intl = read(intlPod);

    if (state.recurring) {
      SuccessScreen.push(
        context: _context,
        secondaryText: intl.previewBuyWithAssetNotifier_orderProcessing,
        then: () {
          read(navigationStpod).state = 1;
        },
      );
    } else {
      RecurringSuccessScreen.push(
        context: _context,
        input: input,
      );
    }
  }

  void _showNoResponseScreen() {
    final intl = read(intlPod);

    return FailureScreen.push(
      context: _context,
      primaryText: intl.showNoResponseScreen_text,
      secondaryText: intl.showNoResponseScreen_text2,
      primaryButtonName: intl.serverCode0_ok,
      onPrimaryButtonTap: () {
        read(navigationStpod).state = 1; // Portfolio
        navigateToRouter(read);
      },
    );
  }

  void _showFailureScreen(ServerRejectException error) {
    final intl = read(intlPod);

    return FailureScreen.push(
      context: _context,
      primaryText: intl.previewBuyWithAssetNotifier_failure,
      secondaryText: error.cause,
      primaryButtonName: intl.previewBuyWithAssetNotifier_editOrder,
      onPrimaryButtonTap: () {
        Navigator.pushAndRemoveUntil(
          _context,
          MaterialPageRoute(
            builder: (_) => CurrencyBuy(
              currency: input.toCurrency,
              fromCard: areBalancesEmpty(
                read(currenciesPod),
              ),
            ),
          ),
          (route) => route.isFirst,
        );
      },
      secondaryButtonName: intl.previewBuyWithAssetNotifier_close,
      onSecondaryButtonTap: () => navigateToRouter(read),
    );
  }

  String get previewHeader {
    final intl = read(intlPod);

    if (input.recurringType == RecurringBuysType.oneTimePurchase) {
      return '${intl.previewBuyWithAssetNotifier_confirmBuy}'
          ' ${input.toCurrency.description}';
    } else {
      return '${intl.previewBuyWithAssetNotifier_confirm}'
          ' ${input.toCurrency.description} ${intl.recurringBuysName_active}';
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
