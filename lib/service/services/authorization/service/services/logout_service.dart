import 'package:dio/dio.dart';

import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_response_codes.dart';
import '../../dto/logout_response_dto.dart';

Future<void> logoutService(Dio dio) async {
  final response = await dio.post(
    '$walletApiBaseUrl/authorization/logout',
  );

  final responseData = response.data as Map<String, dynamic>;

  final responseDto = LogoutResponseDto.fromJson(responseData);

  handleResponseCodes(responseDto.result);
}
