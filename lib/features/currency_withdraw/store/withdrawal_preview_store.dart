import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/router/app_router.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/currency_withdraw/model/withdrawal_model.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_address_store.dart';
import 'package:jetwallet/features/currency_withdraw/store/withdrawal_amount_store.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_kit/modules/shared/stack_loader/store/stack_loader_store.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';
import 'package:simple_networking/modules/wallet_api/models/withdraw/withdraw_request_model.dart';

import '../../../utils/helpers/currency_from.dart';

part 'withdrawal_preview_store.g.dart';

class WithdrawalPreviewStore extends _WithdrawalPreviewStoreBase
    with _$WithdrawalPreviewStore {
  WithdrawalPreviewStore(
    WithdrawalModel withdrawal,
    WithdrawalAmountStore amountStore,
    WithdrawalAddressStore addressStore,
  ) : super(withdrawal, amountStore, addressStore);

  static _WithdrawalPreviewStoreBase of(BuildContext context) =>
      Provider.of<WithdrawalPreviewStore>(context, listen: false);
}

abstract class _WithdrawalPreviewStoreBase with Store {
  _WithdrawalPreviewStoreBase(
    this.withdrawal,
    this.amountStore,
    this.addressStore,
  ) {
    final _amount = amountStore;

    tag = _amount.tag;
    address = _amount.address;
    amount = _amount.amount;
    addressIsInternal = _amount.addressIsInternal;
    blockchain = _amount.blockchain;
  }

  final WithdrawalModel withdrawal;

  final WithdrawalAmountStore amountStore;

  final WithdrawalAddressStore addressStore;

  static final _logger = Logger('WithdrawalPreviewStore');

  final loader = StackLoaderStore();

  @observable
  String tag = '';

  @observable
  String address = '';

  @observable
  String amount = '0';

  @observable
  String operationId = '';

  @observable
  bool addressIsInternal = false;

  @observable
  bool loading = false;

  @observable
  BlockchainModel blockchain = const BlockchainModel();

  @observable
  bool isProcessing = false;

  @action
  Future<void> withdraw() async {
    _logger.log(notifier, 'withdraw');

    loader.startLoading();
    loading = true;

    try {
      final model = WithdrawRequestModel(
        requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        assetSymbol: withdrawal.currency!.symbol,
        amount: Decimal.parse(amount),
        toAddress: address,
        toTag: tag,
        blockchain: blockchain.id,
        lang: intl.localeName,
      );

      final response = await sNetwork.getWalletModule().postWithdraw(model);

      response.pick(
        onData: (data) {
          _updateOperationId(data.operationId);

          _showWithdrawConfirm();
        },
        onError: (error) {
          _logger.log(stateFlow, 'withdraw', error.cause);

          _showFailureScreen(error);
        },
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'withdraw', error.cause);

      _showFailureScreen(error);
    } catch (error) {
      _logger.log(stateFlow, 'withdraw', error);

      _showNoResponseScreen();
    }

    loading = false;
    loader.finishLoadingImmediately();
  }

  @action
  Future<void> withdrawNFT() async {
    _logger.log(notifier, 'withdrawNFT');

    loading = true;
    loader.startLoading();

    final matic = currencyFrom(
      sSignalRModules.currenciesList,
      'MATIC',
    );

    try {
      final model = WithdrawRequestModel(
        requestId: DateTime.now().microsecondsSinceEpoch.toString(),
        assetSymbol: withdrawal.nft!.symbol!,
        amount: withdrawal.nft!.buyPrice!,
        toAddress: address,
        blockchain: withdrawal.nft!.blockchain!,
        lang: intl.localeName,
      );

      final response = await sNetwork.getWalletModule().postWithdraw(model);

      response.pick(
        onData: (data) {

          /*
            sRouter.push(
              SuccessScreenRouter(
                secondaryText: intl.nft_send_confirm,
                showProgressBar: true,
                onSuccess: (context) {
                  sRouter.replaceAll([
                    const HomeRouter(
                      children: [
                        PortfolioRouter(),
                      ],
                    ),
                  ]);
                },
              ),
            );
          */

          _showWithdrawConfirm();
        },
        onError: (error) {
          _logger.log(stateFlow, 'withdraw', error.cause);

          _showFailureScreen(error);
        },
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, 'withdraw', error.cause);

      _showFailureScreen(error);
    } catch (error) {
      _logger.log(stateFlow, 'withdraw', error);

      _showNoResponseScreen();
    }

    loading = false;
    loader.finishLoadingImmediately();
  }

  @action
  void _updateOperationId(String value) {
    operationId = value;
  }

  @action
  void _showWithdrawConfirm() {
    /*sRouter.push(
        WithdrawalConfirmRouter(
        withdrawal: withdrawal,
        previewStore: this as WithdrawalPreviewStore,
        addressStore: addressStore,
      ),
      
        );*/
  }

  @action
  void _showNoResponseScreen() {
    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.showNoResponseScreen_text,
        secondaryText: intl.showNoResponseScreen_text2,
        primaryButtonName: intl.serverCode0_ok,
        onPrimaryButtonTap: () {
          /*sRouter.navigate(
            WithdrawalAmountRouter(
              withdrawal: withdrawal,
              network: '',
              addressStore: addressStore,
            ),
          );*/
        },
      ),
    );
  }

  @action
  void _showFailureScreen(ServerRejectException error) {
    sRouter.push(
      FailureScreenRouter(
        primaryText: intl.withdrawalPreview_failure,
        secondaryText: error.cause,
        primaryButtonName: intl.withdrawalPreview_editOrder,
        onPrimaryButtonTap: () {
          /*sRouter.navigate(
            WithdrawalAmountRouter(
              withdrawal: withdrawal,
              network: blockchain.id,
              addressStore: addressStore,
            ),
          );*/
        },
        secondaryButtonName: intl.withdrawalPreview_close,
        onSecondaryButtonTap: () => sRouter.popUntilRoot(),
      ),
    );
  }
}
