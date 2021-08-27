import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../service/services/blockchain/model/deposit_address/deposit_address_request_model.dart';
import '../../../../../service/services/blockchain/model/deposit_address/deposit_address_response_model.dart';
import '../../../../../shared/providers/service_providers.dart';

final depositAddressFpod =
    FutureProvider.autoDispose.family<DepositAddressResponseModel, String>(
  (ref, assetSymbol) {
    final blockchainService = ref.read(blockchainServicePod);

    final model = DepositAddressRequestModel(
      assetSymbol: assetSymbol,
    );

    return blockchainService.depositAddress(model);
  },
);
