import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../model/profile_info_reponse_model.dart';
import '../profile_service.dart';

Future<ProfileInfoResponseModel> profileInfoService(
  Dio dio,
  String localeName,
) async {
  final logger = ProfileService.logger;
  const message = 'profileInfoService';

  try {
    final response = await dio.get(
      '$walletApi/profile/info',
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeName);

      return ProfileInfoResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
