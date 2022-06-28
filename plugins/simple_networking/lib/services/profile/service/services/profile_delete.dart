// plugins\simple_networking\lib\services\profile\service\services\profile_delete_reasons_service.dart
import 'package:dio/dio.dart';

import '../../../../../shared/api_urls.dart';
import '../../../../../shared/constants.dart';
import '../../model/profile_delete_account_request.dart';
import '../profile_service.dart';

Future<void> profileDeleteService(
  Dio dio,
  List<String> deletionReasonIds,
) async {
  final logger = ProfileService.logger;
  const message = 'profileDeleteService';

  try {
    final response = await dio.post(
      '$walletApi/profile/delete-profile',
      data: ProfileDeleteAccountRequest(
        tokenId: 'tokenID',
        deletionReasonIds: deletionReasonIds,
      ).toJson(),
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      return;
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
