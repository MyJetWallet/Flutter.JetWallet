import 'dart:async';

import 'package:data_channel/data_channel.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/format_service.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/utils/formatting/formatting.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_kit_updated/simple_kit_updated.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/invest_transfer/invest_transfer_request_model.dart';

part 'invest_withdraw_confirmation_store.g.dart';

class InvestWithdrawConfirmationStore extends _InvestWithdrawConfirmationStoreBase
    with _$InvestWithdrawConfirmationStore {
  InvestWithdrawConfirmationStore({
    required super.assetId,
    required super.amount,
  }) : super();

  static InvestWithdrawConfirmationStore of(BuildContext context) =>
      Provider.of<InvestWithdrawConfirmationStore>(context, listen: false);
}

abstract class _InvestWithdrawConfirmationStoreBase with Store {
  _InvestWithdrawConfirmationStoreBase({
    required this.assetId,
    required this.amount,
  }) {
    requestId = DateTime.now().microsecondsSinceEpoch.toString();

    final formatService = getIt.get<FormatService>();
    baseAmount = formatService.convertOneCurrencyToAnotherOne(
      fromCurrency: assetId,
      fromCurrencyAmmount: amount,
      toCurrency: sSignalRModules.baseCurrency.symbol,
      baseCurrency: sSignalRModules.baseCurrency.symbol,
      isMin: true,
    );

    _isChecked();
  }

  final String assetId;

  final Decimal amount;

  @observable
  Decimal baseAmount = Decimal.zero;

  @observable
  bool isTermsAndConditionsChecked = false;

  @computed
  Decimal get selectedAmount => amount;

  @computed
  Decimal get baseCryptoAmount {
    final formatService = getIt.get<FormatService>();

    return formatService.convertOneCurrencyToAnotherOne(
      fromCurrency: assetId,
      fromCurrencyAmmount: amount,
      toCurrency: sSignalRModules.baseCurrency.symbol,
      baseCurrency: sSignalRModules.baseCurrency.symbol,
      isMin: true,
    );
  }

  @computed
  CurrencyModel get currency => getIt.get<FormatService>().findCurrency(
        assetSymbol: assetId,
      );

  @computed
  CurrencyModel get eurCurrency => getIt.get<FormatService>().findCurrency(
        assetSymbol: baseSymbol,
        findInHideTerminalList: true,
      );

  @computed
  String get baseSymbol {
    final baseCurrency = sSignalRModules.baseCurrency;
    return baseCurrency.symbol;
  }

  @observable
  StackLoaderStore loader = StackLoaderStore();

  @observable
  bool showProcessing = false;

  @observable
  bool isWaitingSkipped = false;

  String requestId = '';

  @action
  void toggleCheckbox() {
    isTermsAndConditionsChecked = !isTermsAndConditionsChecked;
    _setIsChecked(isTermsAndConditionsChecked);
  }

  @action
  Future<void> _isChecked() async {
    try {
      final storage = sLocalStorageService;

      final status = await storage.getValue(checkedBankCard);
      if (status != null && status == 'true') {
        isTermsAndConditionsChecked = true;
      }
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'EarnConfirmationStore',
            message: e.toString(),
          );
    }
  }

  @action
  Future<void> _setIsChecked(bool value) async {
    try {
      final storage = sLocalStorageService;

      await storage.setString(checkedBankCard, value.toString());
      isTermsAndConditionsChecked = value;
    } catch (e) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: 'EarnConfirmationStore',
            message: e.toString(),
          );
    }
  }

  @action
  Future<void> confirm() async {
    try {
      showProcessing = true;

      loader.startLoadingImmediately();

      final model = InvestTransferRequestModel(
        amount: amount,
        amountAssetId: assetId,
      );

      final DC<ServerRejectException, dynamic> resp = await sNetwork.getWalletModule().postInvestWithdraw(model);

      if (resp.hasError) {
        await _showFailureScreen(resp.error?.cause ?? '');

        return;
      }

      if (sRouter.currentPath != '/invest_withdraw_confrimation') {
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
        secondaryText: intl.earn_withdrawal_of(
          amount.toFormatCount(
            symbol: currency.symbol,
            accuracy: currency.accuracy,
          ),
        ),
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

    if (sRouter.currentPath != '/invest_withdraw_confrimation') {
      return;
    }

    unawaited(
      sRouter.push(
        FailureScreenRouter(
          primaryText: intl.previewBuyWithAsset_failure,
          secondaryText: error,
        ),
      ),
    );
  }
}
