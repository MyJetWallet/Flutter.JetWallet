import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/dto/response_dto.dart';
import '../../../../shared/helpers/handle_response_codes.dart';
import '../../dto/withdrawal/withdrawal_request_dto.dart';
import '../../dto/withdrawal/withdrawal_response_dto.dart';
import '../../model/withdrawal/withdrawal_request_model.dart';
import '../../model/withdrawal/withdrawal_response_model.dart';

Future<WithdrawalResponseModel> withdrawalService(
  Dio dio,
  WithdrawalRequestModel model,
) async {
  final requestDto = WithdrawalRequestDto.fromModel(model);

  final response = await dio.post(
    '$walletApiBaseUrl/blockchain/withdrawal',
    data: requestDto.toJson(),
  );

  final responseData = response.data as Map<String, dynamic>;

  final responseDto = ResponseDto<WithdrawalResponseDto>.fromJson(responseData);

  handleResponseCodes(responseDto.result);

  return responseDto.data.toModel();
}
