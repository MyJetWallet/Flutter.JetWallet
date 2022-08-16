import 'package:dio/dio.dart';

import '../../../../shared/api_urls.dart';
import '../../../../shared/constants.dart';
import '../../../../shared/helpers/handle_api_responses.dart';
import '../../authentication/service/authentication_service.dart';
import '../model/country_list_response_model.dart';

Future<CountryListResponseModel> getCountryListService(
  Dio dio,
  String localeNameService,
) async {
  final logger = AuthenticationService.logger;
  const message = 'newsService';

  try {
    final response = await dio.get(
      '$authApi/kycprofile/CountryList',
    );

    try {
      final responseData = response.data as Map<String, dynamic>;

      final data = handleFullResponse<Map>(responseData, localeNameService);
      return CountryListResponseModel.fromJson(data);
    } catch (e) {
      logger.log(contract, message);
      rethrow;
    }
  } catch (e) {
    logger.log(transport, message);
    rethrow;
  }
}
