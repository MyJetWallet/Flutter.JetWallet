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
    String localeName,
  ) {
    return depositAddressService(
      dio,
      model,
      localeName,
    );
  }

  Future<ValidateAddressResponseModel> validateAddress(
    ValidateAddressRequestModel model,
    String localeName,
  ) {
    return validateAddressService(
      dio,
      model,
      localeName,
    );
  }

  Future<WithdrawResponseModel> withdraw(
    WithdrawRequestModel model,
    String localeName,
  ) {
    return withdrawService(
      dio,
      model,
      localeName,
    );
  }

  Future<WithdrawalInfoResponseModel> withdrawalInfo(
    WithdrawalInfoRequestModel model,
    String localeName,
  ) {
    return withdrawalInfoService(
      dio,
      model,
      localeName,
    );
  }

  Future<void> withdrawalResend(
    WithdrawalResendRequestModel model,
    String localeName,
  ) {
    return withdrawalResendService(dio, model, localeName);
  }
}
