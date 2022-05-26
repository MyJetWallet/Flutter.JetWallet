import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/calculate_earn_offer_apy/calculate_earn_offer_apy_request_model.dart';
import '../model/calculate_earn_offer_apy/calculate_earn_offer_apy_response_model.dart';
import '../model/earn_offer_deposit/earn_offer_deposit_request_model.dart';
import '../model/earn_offer_withdrawal/earn_offer_withdrawal_request_model.dart';
import 'services/calculate_earn_offer_apy_service.dart';
import 'services/earn_offer_deposit_service.dart';
import 'services/earn_offer_withdrawal_service.dart';

class HighYieldService {
  HighYieldService(this.dio);

  final Dio dio;

  static final logger = Logger('HighYieldService');

  Future<CalculateEarnOfferApyResponseModel> calculateEarnOfferApy(
    CalculateEarnOfferApyRequestModel model,
    String localeName,
  ) {
    return calculateEarnOfferApyService(dio, model, localeName);
  }

  Future<void> earnOfferDeposit(
    EarnOfferDepositRequestModel model,
    String localeName,
  ) {
    return earnOfferDepositService(dio, model, localeName);
  }

  Future<void> earnOfferWithdrawal(
    EarnOfferWithdrawalRequestModel model,
    String localeName,
  ) {
    return earnOfferWithdrawalService(dio, model, localeName);
  }
}
