import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/deposit_address/deposit_address_request_model.dart';
import '../model/deposit_address/deposit_address_response_model.dart';
import '../model/validate_address/validate_address_request_model.dart';
import '../model/validate_address/validate_address_response_model.dart';
import '../model/withdraw/withdraw_request_model.dart';
import '../model/withdraw/withdraw_response_model.dart';
import '../model/withdrawal_info/withdrawal_info_request_model.dart';
import '../model/withdrawal_info/withdrawal_info_response_model.dart';
import '../model/withdrawal_resend/withdrawal_resend_request.dart';
import 'services/deposit_address_service.dart';
import 'services/validate_address_service.dart';
import 'services/withdraw_service.dart';
import 'services/withdrawal_info_service.dart';
import 'services/withdrawal_resend_service.dart';

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

  Future<WithdrawResponseModel> withdraw(WithdrawRequestModel model) {
    return withdrawService(dio, model);
  }

  Future<WithdrawalInfoResponseModel> withdrawalInfo(
    WithdrawalInfoRequestModel model,
  ) {
    return withdrawalInfoService(dio, model);
  }

  Future<void> withdrawalResend(WithdrawalResendRequestModel model) {
    return withdrawalResendService(dio, model);
  }
}
