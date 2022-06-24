// plugins\simple_networking\lib\services\profile\service\services\profile_delete_reasons_service.dart
import 'package:dio/dio.dart';
import 'package:simple_networking/services/profile/model/profile_delete_reasons_model.dart';
import 'package:simple_networking/services/profile/service/profile_service.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';

Future<ProfileDeleteReasonsModel> profileDeleteReasonsService(
  Dio dio,
  String localeName,
) async {
  final logger = ProfileService.logger;
  const message = 'profileDeleteReasonsService';

  try {
    final response = await dio.post(
      '$walletApi/profile/delete-reasons',
      data: {'lang': localeName},
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeName);

      print(data);

      return ProfileDeleteReasonsModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
