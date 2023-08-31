import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/return_to_wallet/model/preview_return_to_wallet_input.dart';
import 'package:jetwallet/features/return_to_wallet/model/preview_return_to_wallet_union.dart';
import 'package:jetwallet/utils/helpers/navigate_to_router.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/wallet_api/models/earn_offer_withdrawal/earn_offer_withdrawal_request_model.dart';
part 'preview_return_to_wallet_store.g.dart';

class PreviewReturnToWalletStore extends _PreviewReturnToWalletStoreBase
    with _$PreviewReturnToWalletStore {
  PreviewReturnToWalletStore(PreviewReturnToWalletInput input) : super(input);

  static _PreviewReturnToWalletStoreBase of(BuildContext context) =>
      Provider.of<PreviewReturnToWalletStore>(context, listen: false);
}

abstract class _PreviewReturnToWalletStoreBase with Store {
  _PreviewReturnToWalletStoreBase(this.input) {
    _updateFrom(input);
    initBaseData();
  }

  final PreviewReturnToWalletInput input;

  static final _logger = Logger('PreviewReturnToWalletStore');

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
  @observable
  AnimationController? timerAnimation;

  @observable
  bool connectingToServer = false;

  @observable
  PreviewReturnToWalletUnion union =
      const PreviewReturnToWalletUnion.quoteLoading();

  @observable
  int timer = 0;

  @observable
  Decimal? apy;

  @observable
  Decimal? expectedYearlyProfit;

  @observable
  Decimal? expectedYearlyProfitBase;

  @action
  void _updateFrom(PreviewReturnToWalletInput input) {
    fromAssetAmount = Decimal.parse(input.amount);
    fromAssetSymbol = input.fromCurrency.symbol;
    toAssetSymbol = input.toCurrency.symbol;
  }

  @action
  Future<void> initBaseData() async {
    _logger.log(notifier, 'initBaseData');

    union = const PreviewReturnToWalletUnion.quoteSuccess();
  }

  @action
  Future<void> earnOfferWithdrawal(String offerId) async {
    _logger.log(notifier, 'earnOfferWithdrawal');

    union = const PreviewReturnToWalletUnion.quoteLoading();

    try {
      final model = EarnOfferWithdrawalRequestModel(
        requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        offerId: offerId,
        assetSymbol: fromAssetSymbol ?? '',
        amount: fromAssetAmount ?? Decimal.zero,
      );

      final _ = await sNetwork.getWalletModule().postEarnOfferWithdrawal(model);

      _showSuccessScreen();
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'earnOfferWithdrawal', error.cause);

      _showFailureScreen(error);
    } catch (error) {
      _logger.log(stateFlow, 'earnOfferWithdrawal', error);

      _showFailureScreen(
        ServerRejectException(
          intl.preview_return_to_wallet_error,
        ),
      );
    }
  }

  @action
  void _showSuccessScreen() {
    sRouter.push(
      SuccessScreenRouter(
        secondaryText: intl.success_preview_return_to_wallet_message,
      ),
    );
  }

  @action
  void _showFailureScreen(ServerRejectException error) {
    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.failure_preview_return_to_wallet_message,
        secondaryText: error.cause,
        primaryButtonName: intl.failure_preview_return_to_wallet_close,
        onPrimaryButtonTap: () => navigateToRouter(),
      ),
    );
  }
}
