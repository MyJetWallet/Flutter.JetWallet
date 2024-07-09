import 'dart:async';

import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/remote_config/remote_config_values.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_asset_input.dart';
import 'package:jetwallet/features/currency_buy/models/preview_buy_with_asset_union.dart';
import 'package:jetwallet/features/home/store/bottom_bar_store.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/widgets/quote_updated_dialog.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/actions/confirm_action_timer/simple_timer_animation_countdown.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/get_quote/get_quote_response_model.dart';
import 'package:simple_networking/modules/wallet_api/models/swap_execute_quote/execute_quote_request_model.dart';

import '../../../core/di/di.dart';

part 'preview_buy_with_asset_store.g.dart';

class PreviewBuyWithAssetStore extends _PreviewBuyWithAssetStoreBase with _$PreviewBuyWithAssetStore {
  PreviewBuyWithAssetStore(super.input);

  static _PreviewBuyWithAssetStoreBase of(BuildContext context) =>
      Provider.of<PreviewBuyWithAssetStore>(context, listen: false);
}

abstract class _PreviewBuyWithAssetStoreBase with Store {
  _PreviewBuyWithAssetStoreBase(this.input) {
    _updateFrom(input);
    requestQuote();
  }

  final PreviewBuyWithAssetInput input;

  Timer _timer = Timer(Duration.zero, () {});

  static final _logger = Logger('PreviewBuyWithAssetStore');

  final StackLoaderStore loader = StackLoaderStore();

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

  @observable
  RecurringBuyInfoModel? recurringBuyInfo;

  // Will be initialzied on initState of the parent widget
  AnimationController? timerAnimation;

  // [true] when requestQuote() takes too long
  @observable
  bool connectingToServer = false;

  @observable
  PreviewBuyWithAssetUnion union = const PreviewBuyWithAssetUnion.quoteLoading();

  @observable
  int timer = 0;

  @observable
  RecurringBuysType recurringType = RecurringBuysType.oneTimePurchase;

  @computed
  bool get recurring => recurringType != RecurringBuysType.oneTimePurchase;

  @action
  void _updateFrom(PreviewBuyWithAssetInput input) {
    fromAssetAmount = Decimal.parse(input.amount);
    fromAssetSymbol = input.fromCurrency.symbol;
    toAssetSymbol = input.toCurrency.symbol;
    recurringType = input.recurringType;
  }

  @action
  Future<void> requestQuote() async {
    _logger.log(notifier, 'requestQuote');

    //union = const PreviewBuyWithAssetUnion.quoteLoading();

    final recurringBuy = recurringType == RecurringBuysType.oneTimePurchase
        ? null
        : RecurringBuyModel(
            scheduleType: recurringType,
          );

    final model = GetQuoteRequestModel(
      fromAssetAmount: fromAssetAmount,
      fromAssetSymbol: fromAssetSymbol!,
      toAssetSymbol: toAssetSymbol!,
      recurringBuy: recurringBuy,
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
          union = const PreviewBuyWithAssetUnion.quoteSuccess();
          connectingToServer = false;
          feePercent = data.feePercent;
          recurringBuyInfo = data.recurringBuyInfo;

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

      unawaited(_showFailureScreen(error));
    } catch (error) {
      _logger.log(stateFlow, 'requestQuote', error);

      union = const PreviewBuyWithAssetUnion.quoteLoading();
      connectingToServer = true;

      _refreshTimer(quoteRetryInterval);
    }
  }

  @action
  Future<void> executeQuote() async {
    _logger.log(notifier, 'executeQuote');

    union = const PreviewBuyWithAssetUnion.executeLoading();

    try {
      final model = ExecuteQuoteRequestModel(
        operationId: operationId!,
        price: price!,
        fromAssetSymbol: fromAssetSymbol!,
        toAssetSymbol: toAssetSymbol!,
        fromAssetAmount: fromAssetAmount,
        toAssetAmount: toAssetAmount,
        recurringBuyInfo: recurringBuyInfo,
      );

      final response = await sNetwork.getWalletModule().postExecuteQuote(model);

      response.pick(
        onData: (data) {
          if (data.isExecuted) {
            _timer.cancel();
            _showSuccessScreen();
          } else {
            union = const PreviewBuyWithAssetUnion.quoteSuccess();
            _timer.cancel();

            if (recurring) return;

            showQuoteUpdatedDialog(
              context: sRouter.navigatorKey.currentContext!,
              onPressed: () => requestQuote(),
            );
          }
        },
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'executeQuote', error.cause);

      _timer.cancel();
      unawaited(_showFailureScreen(error));
    } catch (error) {
      _logger.log(stateFlow, 'executeQuote', error);

      _timer.cancel();
      unawaited(_showNoResponseScreen());
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
  void _showSuccessScreen() {
    if (recurring) {
      sRouter.push(
        SuccessScreenRouter(
          secondaryText: intl.previewBuyWithAsset_orderProcessing,
          onSuccess: (context) {
            getIt<BottomBarStore>().setHomeTab(BottomItemType.wallets);
            sRouter.push(
              const HomeRouter(
                children: [
                  MyWalletsRouter(),
                ],
              ),
            );
          },
        ),
      );
    } else {}
  }

  @action
  Future<void> _showNoResponseScreen() {
    return sRouter.push(
      FailureScreenRouter(
        primaryText: intl.showNoResponseScreen_text,
        secondaryText: intl.showNoResponseScreen_text2,
        primaryButtonName: intl.serverCode0_ok,
        onPrimaryButtonTap: () {
          sRouter.push(
            const HomeRouter(
              children: [
                MyWalletsRouter(),
              ],
            ),
          );
        },
      ),
    );
  }

  @action
  Future<void> _showFailureScreen(ServerRejectException error) {
    return sRouter.push(
      FailureScreenRouter(
        primaryText: intl.previewBuyWithAsset_failure,
        secondaryText: error.cause,
        primaryButtonName: intl.previewBuyWithAsset_close,
        onPrimaryButtonTap: () => navigateToRouter(),
      ),
    );
  }

  @computed
  String get previewHeader {
    return input.recurringType == RecurringBuysType.oneTimePurchase
        ? '${intl.previewBuyWithAsset_confirmBuy}'
            ' ${input.toCurrency.description}'
        : '${intl.previewBuyWithAsset_confirm}'
            ' ${input.toCurrency.description} ';
  }

  @action
  void dispose() {
    _timer.cancel();
  }
}
