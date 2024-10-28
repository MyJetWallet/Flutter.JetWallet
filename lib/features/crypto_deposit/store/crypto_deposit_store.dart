import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jetwallet/core/services/notification_service.dart';
import 'package:jetwallet/core/services/signal_r/signal_r_service_new.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:jetwallet/features/crypto_deposit/model/crypto_deposit_union.dart';
import 'package:jetwallet/utils/helpers/currency_from.dart';
import 'package:jetwallet/utils/logging.dart';
import 'package:jetwallet/utils/models/currency_model.dart';
import 'package:logging/logging.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:simple_analytics/simple_analytics.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/signal_r/models/blockchains_model.dart';
import 'package:simple_networking/modules/wallet_api/models/deposit_address/deposit_address_request_model.dart';

part 'crypto_deposit_store.g.dart';

const _retryTime = 5; // in seconds

class CryptoDepositStore extends _CryptoDepositStoreBase with _$CryptoDepositStore {
  CryptoDepositStore({required String assetSymbol})
      : super(
          currencyFrom(
            sSignalRModules.currenciesList,
            assetSymbol,
          ),
        );

  static _CryptoDepositStoreBase of(BuildContext context) => Provider.of<CryptoDepositStore>(context, listen: false);
}

abstract class _CryptoDepositStoreBase with Store {
  _CryptoDepositStoreBase(this.currency) {
    if (currency.isSingleNetwork) {
      network = currency.depositBlockchains[0];

      _requestDepositAddress();
    }
  }

  late final CurrencyModel currency;

  static final _logger = Logger('CurrencyDepositStore');

  Timer? _timer;
  late int retryTime;

  @observable
  String? tag;

  @observable
  bool isAddressOpen = true;

  @observable
  String address = '';

  @observable
  CryptoDepositUnion union = const CryptoDepositUnion.loading();

  @observable
  BlockchainModel network = const BlockchainModel();

  @action
  void switchAddress() {
    _logger.log(notifier, 'switchAddress');

    isAddressOpen = !isAddressOpen;
  }

  @action
  void setNetwork(BlockchainModel newNetwork) {
    _logger.log(notifier, 'setNetwork');

    network = newNetwork;

    sAnalytics.receiveAssetScreenView(
      asset: currency.symbol,
      network: network.description,
    );

    _requestDepositAddress();
  }

  @action
  Future<void> _requestDepositAddress() async {
    union = const CryptoDepositUnion.loading();

    try {
      final model = DepositAddressRequestModel(
        assetSymbol: currency.symbol,
        blockchain: network.id,
      );

      final response = await sNetwork.getWalletModule().postDepositAddress(model);

      response.pick(
        onData: (data) {
          if (data.address == null) {
            throw 'Address is Null';
          }

          address = data.address!;
          tag = data.memo;
          union = const CryptoDepositUnion.success();
        },
        onError: (error) {
          _logger.log(stateFlow, '_requestDepositAddress', error.cause);

          sNotification.showError(
            error.cause,
            id: 1,
          );
        },
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, '_requestDepositAddress', error.cause);

      sNotification.showError(
        error.cause,
        id: 1,
      );
    } catch (error) {
      _logger.log(stateFlow, '_requestDepositAddress', error);

      union = const CryptoDepositUnion.loading();

      _refreshTimer();
    }
  }

  @action
  void _refreshTimer() {
    _timer?.cancel();
    retryTime = _retryTime;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (retryTime == 0) {
          timer.cancel();
          _requestDepositAddress();
        } else {
          retryTime -= 1;
        }
      },
    );
  }

  @action
  void dispose() {
    _timer?.cancel();
  }
}
