import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/dto/response_dto.dart';
import '../../../../shared/helpers/handle_response_codes.dart';
import '../../dto/deposit_address/deposit_address_request_dto.dart';
import '../../dto/deposit_address/deposit_address_response_dto.dart';
import '../../model/deposit_address/deposit_address_request_model.dart';
import '../../model/deposit_address/deposit_address_response_model.dart';

Future<DepositAddressResponseModel> depositAddressService(
  Dio dio,
  DepositAddressRequestModel model,
) async {
  final requestDto = DepositAddressRequestDto.fromModel(model);

  final response = await dio.post(
    '$walletApiBaseUrl/blockchain/generate-deposit-address',
    data: requestDto.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  final responseDto = ResponseDto<DepositAddressResponseDto>.fromJson(
    responseData,
  );

  handleResponseCodes(responseDto.result);

  return responseDto.data.toModel();
}
