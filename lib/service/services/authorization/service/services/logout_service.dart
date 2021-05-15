import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/dto/reponse_codes_dto.dart';
import '../../../../shared/helpers/handle_response_codes.dart';

Future<void> logoutService(Dio dio) async {
  final response = await dio.post(
    '$walletApiBaseUrl/authorization/logout',
  );

  final responseData = response.data as Map<String, dynamic>;

  final responseDto = ResponseCodesDto.fromJson(responseData);

  handleResponseCodes(responseDto);
}
