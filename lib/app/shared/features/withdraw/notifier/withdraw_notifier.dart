import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/blockchain/model/validate_address/validate_address_request_model.dart';
import '../../../../../service/services/blockchain/model/withdrawal/withdrawal_request_model.dart';
import '../../../../../service/services/blockchain/service/blockchain_service.dart';
import 'withdraw_state.dart';
import 'withdraw_union.dart';

class WithdrawNotifier extends StateNotifier<WithdrawState> {
  WithdrawNotifier({
    required this.blockchainService,
    required this.assetSymbol,
  }) : super(
          const WithdrawState(
            address: '',
            amount: 0,
            union: Input(),
          ),
        );

  final BlockchainService blockchainService;
  final String assetSymbol;

  void updateAddress(String address) {
    state = state.copyWith(address: address);
  }

  void updateMemo(String memo) {
    state = state.copyWith(memo: memo);
  }

  void updateAmount(String amount) {
    state = state.copyWith(
      amount: int.parse(amount),
    );
  }

  Future<bool> withdraw() async {
    state = state.copyWith(union: const Loading());

    final model = ValidateAddressRequestModel(
      assetSymbol: assetSymbol,
      toAddress: state.address,
    );

    try {
      final validateResult = await blockchainService.validateAddress(model);

      if (validateResult.isValid) {
        final model = WithdrawalRequestModel(
          requestId: DateTime.now().microsecondsSinceEpoch.toString(),
          assetSymbol: assetSymbol,
          amount: state.amount,
          toAddress: state.address,
        );

        await blockchainService.withdrawal(model);

        return true;
      } else {
        state = state.copyWith(union: const Input('Invalid Address'));
      }
    } catch (e, st) {
      state = state.copyWith(union: Input(e, st));
    }

    return false;
  }
}
