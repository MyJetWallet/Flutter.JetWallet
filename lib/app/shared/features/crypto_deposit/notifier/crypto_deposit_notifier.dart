import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';
import 'package:simple_kit/simple_kit.dart';
import 'package:simple_networking/services/blockchain/model/deposit_address/deposit_address_request_model.dart';
import 'package:simple_networking/services/signal_r/model/blockchains_model.dart';
import 'package:simple_networking/shared/models/server_reject_exception.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import '../../../models/currency_model.dart';
import 'crypto_deposit_state.dart';
import 'crypto_deposit_union.dart';

const _retryTime = 5; // in seconds

class CryptoDepositNotifier extends StateNotifier<CryptoDepositState> {
  CryptoDepositNotifier({
    required this.read,
    required this.currency,
  }) : super(const CryptoDepositState()) {
    if (currency.isSingleNetwork) {
      state = state.copyWith(
        network: currency.depositBlockchains[0],
      );

      _requestDepositAddress();
    }
  }

  final Reader read;
  final CurrencyModel currency;

  static final _logger = Logger('CurrencyDepositNotifier');

  Timer? _timer;
  late int retryTime;

  void switchAddress() {
    _logger.log(notifier, 'switchAddress');

    state = state.copyWith(
      isAddressOpen: !state.isAddressOpen,
    );
  }

  void setNetwork(BlockchainModel network) {
    _logger.log(notifier, 'setNetwork');

    state = state.copyWith(
      network: network,
    );

    _requestDepositAddress();
  }

  Future<void> _requestDepositAddress() async {
    state = state.copyWith(union: const Loading());

    try {
      final service = read(blockchainServicePod);

      final model = DepositAddressRequestModel(
        assetSymbol: currency.symbol,
        blockchain: state.network.id,
      );

      final response = await service.depositAddress(model);

      if (response.address == null) {
        throw 'Address is Null';
      }

      state = state.copyWith(
        address: response.address!,
        tag: response.memo,
        union: const Success(),
      );
    } on ServerRejectException catch (error) {
      _logger.log(stateFlow, '_requestDepositAddress', error.cause);

      read(sNotificationNotipod.notifier).showError(
        error.cause,
        id: 1,
      );

      state = state.copyWith(union: const Loading());
    } catch (error) {
      _logger.log(stateFlow, '_requestDepositAddress', error);

      state = state.copyWith(union: const Loading());

      _refreshTimer();
    }
  }

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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
