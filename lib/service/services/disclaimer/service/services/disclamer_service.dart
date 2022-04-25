import 'package:dio/dio.dart';

import '../../../../../shared/logging/levels.dart';
import '../../../../../shared/services/remote_config_service/remote_config_values.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/disclaimers_response_model.dart';
import '../disclaimers_service.dart';

Future<DisclaimersResponseModel> getDisclaimersService(Dio dio) async {
  final logger = DisclaimersService.logger;
  const message = 'getDisclaimersService';

  try {
    final response = await dio.get(
      '$walletApi/profile/disclaimers',
    );

    try {
      final responseData = response.data as Map<String, dynamic>;
      print('|||| $responseData');
      final data = handleFullResponse<Map>(responseData);

      print('|aa|| $data');
      final res = DisclaimersResponseModel.fromJson(data);
      print('|aa|| $res');
      return res;
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}

Future<void> postDisclaimersService(Dio dio) async {
  final logger = DisclaimersService.logger;
  const message = 'profileInfoService';

  try {
    final response = await dio.get(
      '$walletApi/profile/info',
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData);

      // return ProfileInfoResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}