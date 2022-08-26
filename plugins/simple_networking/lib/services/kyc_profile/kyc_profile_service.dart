import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'model/apply_user_data_request_model.dart';
import 'model/country_list_response_model.dart';
import 'service/apply_user_data_service.dart';
import 'service/session_check.dart';

class KycProfileService {
  KycProfileService(this.dio);

  final Dio dio;

  static final logger = Logger('KycProfileService');

  Future<CountryListResponseModel> getCountryList(
    String localeName,
  ) {
    return getCountryListService(dio, localeName);
  }

  Future<void> applyUsedData(
    ApplyUseDataRequestModel model,
    String localName,
  ) {
    return applyUsedDataService(dio, model, localName);
  }
}
