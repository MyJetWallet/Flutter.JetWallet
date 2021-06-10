import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/validate_address/validate_address_request_model.dart';
import '../../model/validate_address/validate_address_response_model.dart';

Future<ValidateAddressResponseModel> validateAddressService(
  Dio dio,
  ValidateAddressRequestModel model,
) async {
  final response = await dio.post(
    '$walletApiBaseUrl/blockchain/validate-address',
    data: model.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  final data = handleFullResponse<Map>(responseData);

  return ValidateAddressResponseModel.fromJson(data);
}
