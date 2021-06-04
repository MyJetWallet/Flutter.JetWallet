import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
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

  final data = handleFullResponse<Map>(responseData);

  final responseDto = WithdrawalResponseDto.fromJson(data);

  return responseDto.toModel();
}
