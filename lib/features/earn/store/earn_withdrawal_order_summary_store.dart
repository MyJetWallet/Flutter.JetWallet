import 'dart:async';

import 'package:data_channel/data_channel.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/active_earn_positions_model.dart';
import 'package:simple_networking/modules/wallet_api/models/earn_close_position/earn_close_position_request_model.dart';
import 'package:simple_networking/modules/wallet_api/models/earn_withdraw_position/earn_withdraw_position_request_model.dart';

part 'earn_withdrawal_order_summary_store.g.dart';

class EarnWithdrawalOrderSummaryStore extends _EarnWithdrawalOrderSummaryStoreBase
    with _$EarnWithdrawalOrderSummaryStore {
  EarnWithdrawalOrderSummaryStore({
    required super.earnPosition,
    required super.amount,
    required super.isClosing,
  }) : super();

  static EarnWithdrawalOrderSummaryStore of(BuildContext context) =>
      Provider.of<EarnWithdrawalOrderSummaryStore>(context, listen: false);
}

abstract class _EarnWithdrawalOrderSummaryStoreBase with Store {
  _EarnWithdrawalOrderSummaryStoreBase({
    required this.earnPosition,
    required this.amount,
    required this.isClosing,
  }) {
    requestId = DateTime.now().microsecondsSinceEpoch.toString();

    final formatService = getIt.get<FormatService>();
    baseAmount = formatService.convertOneCurrencyToAnotherOne(
      fromCurrency: earnPosition.assetId,
      fromCurrencyAmmount: amount,
      toCurrency: sSignalRModules.baseCurrency.symbol,
      baseCurrency: sSignalRModules.baseCurrency.symbol,
      isMin: true,
    );
  }

  final EarnPositionClientModel earnPosition;
  final Decimal amount;
  final bool isClosing;

  @observable
  Decimal baseAmount = Decimal.zero;

  @computed
  CurrencyModel get currency => getIt.get<FormatService>().findCurrency(
        assetSymbol: earnPosition.assetId,
      );

  @computed
  CurrencyModel get eurCurrency => getIt.get<FormatService>().findCurrency(
        assetSymbol: 'EUR',
      );

  @observable
  StackLoaderStore loader = StackLoaderStore();

  @observable
  bool showProcessing = false;

  @observable
  bool isWaitingSkipped = false;

  String requestId = '';

  @action
  Future<void> confirm() async {
    try {
      showProcessing = true;

      loader.startLoadingImmediately();

      late final DC<ServerRejectException, dynamic> resp;

      if (isClosing) {
        final model = EarnColosePositionRequestModel(
          requestId: requestId,
          positionId: earnPosition.id,
        );

        resp = await sNetwork.getWalletModule().postEarnClosePosition(model);
      } else {
        final model = EarnWithdrawPositionRequestModel(
          requestId: requestId,
          positionId: earnPosition.id,
          amount: amount,
        );

        resp = await sNetwork.getWalletModule().postEarnWithdrawPosition(model);
      }

      if (resp.hasError) {
        await _showFailureScreen(resp.error?.cause ?? '');

        return;
      }

      if (sRouter.currentPath != '/earn_withdraw_order_summary') {
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
  void skippedWaiting() {
    isWaitingSkipped = true;
  }

  @action
  Future<void> _showSuccessScreen(bool isGoogle) {
    return sRouter
        .push(
      SuccessScreenRouter(
        secondaryText: intl.earn_withdraw_successfully,
        buttonText: intl.previewBuyWithUmlimint_saveCard,
        showProgressBar: true,
      ),
    )
        .then((value) {
      sRouter.replaceAll([
        const HomeRouter(
          children: [],
        ),
      ]);
    });
  }

  @action
  Future<void> _showFailureScreen(String error) async {
    loader.finishLoadingImmediately();

    if (sRouter.currentPath != '/earn_withdraw_order_summary') {
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
}
