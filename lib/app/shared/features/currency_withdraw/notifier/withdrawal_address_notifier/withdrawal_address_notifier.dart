import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logging/logging.dart';

import '../../../../../../service/services/blockchain/model/validate_address/validate_address_request_model.dart';
import '../../../../../../shared/logging/levels.dart';
import '../../../../../../shared/providers/service_providers.dart';
import '../../../../models/currency_model.dart';
import 'address_validation_union.dart';
import 'withdrawal_address_state.dart';

/// Responsible for input and validation of withdrawal address and tag
class WithdrawalAddressNotifier extends StateNotifier<WithdrawalAddressState> {
  WithdrawalAddressNotifier(
    this.read,
    this.currency,
  ) : super(const WithdrawalAddressState());

  final Reader read;
  final CurrencyModel currency;

  static final _logger = Logger('WithdrawalAddressNotifier');

  void updateAddress(String address) {
    _logger.log(notifier, 'updateAddress');

    state = state.copyWith(address: address);
    _validateAddress();
  }

  void updateTag(String tag) {
    _logger.log(notifier, 'updateTag');

    state = state.copyWith(tag: tag);
    _validateAddress();
  }

  Future<void> _validateAddress() async {
    state = state.copyWith(validation: const Loading());

    try {
      // TODO add toTag parameter when Alexey will update contract
      final model = ValidateAddressRequestModel(
        assetSymbol: currency.symbol,
        toAddress: state.address,
      );

      final service = read(blockchainServicePod);

      final response = await service.validateAddress(model);

      state = state.copyWith(
        validation: response.isValid ? const Valid() : const Invalid(),
      );
    } catch (error) {
      _logger.log(stateFlow, '_validateAddress', error);
      state = state.copyWith(validation: const Invalid());
    }
  }
}
