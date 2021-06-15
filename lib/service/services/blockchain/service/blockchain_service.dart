import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/deposit_address/deposit_address_request_model.dart';
import '../model/deposit_address/deposit_address_response_model.dart';
import '../model/validate_address/validate_address_request_model.dart';
import '../model/validate_address/validate_address_response_model.dart';
import '../model/withdrawal/withdrawal_request_model.dart';
import '../model/withdrawal/withdrawal_response_model.dart';
import 'services/deposit_address_service.dart';
import 'services/validate_address_service.dart';
import 'services/withdrawal_service.dart';

class BlockchainService {
  BlockchainService(this.dio);

  final Dio dio;

  static final logger = Logger('BlockchainService');

  Future<DepositAddressResponseModel> depositAddress(
    DepositAddressRequestModel model,
  ) {
    return depositAddressService(dio, model);
  }

  Future<ValidateAddressResponseModel> validateAddress(
    ValidateAddressRequestModel model,
  ) {
    return validateAddressService(dio, model);
  }

  Future<WithdrawalResponseModel> withdrawal(WithdrawalRequestModel model) {
    return withdrawalService(dio, model);
  }
}
