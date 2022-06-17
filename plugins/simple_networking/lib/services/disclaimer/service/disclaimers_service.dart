import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/disclaimers_request_model.dart';
import '../model/disclaimers_response_model.dart';
import 'services/get_disclaimer_service.dart';
import 'services/get_high_yield_disclaimer_service.dart';
import 'services/save_disclaimer_service.dart';

class DisclaimersService {
  DisclaimersService(this.dio);

  final Dio dio;

  static final logger = Logger('DisclaimersService');

  Future<DisclaimersResponseModel> disclaimers(String localeName) {
    return getDisclaimersService(
      dio,
      localeName,
    );
  }

  Future<DisclaimersResponseModel> highYieldDisclaimers(String localeName) {
    return getHighYieldDisclaimersService(
      dio,
      localeName,
    );
  }

  Future<void> saveDisclaimer(
    DisclaimersRequestModel model,
    String localeName,
  ) async {
    await saveDisclaimerService(dio, model, localeName);
  }
}
