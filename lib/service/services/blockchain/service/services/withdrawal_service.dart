import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/withdrawal/withdrawal_request_model.dart';
import '../../model/withdrawal/withdrawal_response_model.dart';

Future<WithdrawalResponseModel> withdrawalService(
  Dio dio,
  WithdrawalRequestModel model,
) async {
  final response = await dio.post(
    '$walletApiBaseUrl/blockchain/withdrawal',
    data: model.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  final data = handleFullResponse<Map>(responseData);

  return WithdrawalResponseModel.fromJson(data);
}
