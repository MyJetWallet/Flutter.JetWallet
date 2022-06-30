// plugins\simple_networking\lib\services\profile\service\services\profile_delete_reasons_service.dart
import 'package:dio/dio.dart';

import '../../../../../shared/api_urls.dart';
import '../../../../../shared/constants.dart';
import '../../model/profile_delete_reasons_model.dart';
import '../../model/profile_delete_reasons_request_model.dart';
import '../profile_service.dart';

Future<List<ProfileDeleteReasonsModel>> profileDeleteReasonsService(
  Dio dio,
  String localeName,
) async {
  final logger = ProfileService.logger;
  const message = 'profileDeleteReasonsService';

  try {
    final response = await dio.post(
      '$walletApi/profile/delete-reasons',
      data: ProfileDeleteReasonsRequestModel(language: localeName).toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final out = <ProfileDeleteReasonsModel>[];
      for (final element in responseData['data']) {
        out.add(
          ProfileDeleteReasonsModel.fromJson(element as Map<String, dynamic>),
        );
      }

      return out;
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
