import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../service/services/blockchain/model/deposit_address/deposit_address_request_model.dart';
import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/providers/service_providers.dart';
import 'currency_deposit_state.dart';
import 'currency_deposit_union.dart';

const _retryTime = 5; // in seconds

class CurrencyDepositNotifier extends StateNotifier<CurrencyDepositState> {
  CurrencyDepositNotifier({
    required this.read,
    required this.assetSymbol,
  }) : super(const CurrencyDepositState()) {
    _requestDepositAddress();
  }

  final Reader read;
  final String assetSymbol;

  static final _logger = Logger('CurrencyDepositNotifier');

  Timer? _timer;
  late int retryTime;

  void switchQr() {
    _logger.log(notifier, 'switchQr');

    state = state.copyWith(
      openAddress: state.openTag,
      openTag: state.openAddress,
    );
  }

  Future<void> _requestDepositAddress() async {
    state = state.copyWith(union: const Loading());

    try {
      final service = read(blockchainServicePod);

      final model = DepositAddressRequestModel(
        assetSymbol: assetSymbol,
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
