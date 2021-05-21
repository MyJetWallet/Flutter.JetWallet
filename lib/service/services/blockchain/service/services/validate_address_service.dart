import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_response_codes.dart';
import '../../dto/validate_address/validate_address_request_dto.dart';
import '../../dto/validate_address/validate_address_response_dto.dart';
import '../../model/validate_address/validate_address_request_model.dart';
import '../../model/validate_address/validate_address_response_model.dart';

Future<ValidateAddressResponseModel> validateAddressService(
  Dio dio,
  ValidateAddressRequestModel model,
) async {
  final requestDto = ValidateAddressRequestDto.fromModel(model);

  final response = await dio.post(
    '$walletApiBaseUrl/blockchain/validate-address',
    data: requestDto.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  final responseDto = ValidateAddressFullResponseDto.fromJson(
    responseData,
  );

  handleResponseCodes(responseDto.result);

  return responseDto.data!.toModel();
}
