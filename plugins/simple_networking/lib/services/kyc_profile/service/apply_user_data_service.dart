import 'package:dio/dio.dart';

import '../../../shared/api_urls.dart';
import '../../../shared/constants.dart';
import '../../../shared/helpers/handle_api_responses.dart';
import '../../wallet/service/wallet_service.dart';
import '../model/apply_user_data_request_model.dart';

Future<void> applyUsedDataService(
  Dio dio,
  ApplyUseDataRequestModel model,
  String localeName,
) async {
  final logger = WalletService.logger;
  const message = 'applyUsedDataService';

  try {
    final response = await dio.post(
      '$authApi/kycprofile/Apply',
      data: model.toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;
      handleResultResponse(responseData, localeName);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
