import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/deposit_address/deposit_address_request_model.dart';
import '../../model/deposit_address/deposit_address_response_model.dart';

Future<DepositAddressResponseModel> depositAddressService(
  Dio dio,
  DepositAddressRequestModel model,
) async {
  final response = await dio.post(
    '$walletApiBaseUrl/blockchain/generate-deposit-address',
    data: model.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  final data = handleFullResponse<Map>(responseData);

  return DepositAddressResponseModel.fromJson(data);
}
