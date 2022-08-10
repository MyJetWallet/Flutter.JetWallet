import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import 'model/change_pin/change_pin_response_model.dart';
import 'model/check_pin/check_pin_response_model.dart';
import 'model/setup_pin/setup_pin_response_model.dart';
import 'services/change_pin_service.dart';
import 'services/check_pin_service.dart';
import 'services/setup_pin_service.dart';

class PinService {
  PinService(this.dio);

  final Dio dio;

  static final logger = Logger('PinService');

  Future<ChangePinResponseModel> changePin(
      String localeName, String oldPin, String newPin,) {
    return changePinService(dio, localeName, oldPin, newPin,);
  }

  Future<CheckPinResponseModel> checkPin(String localeName, String pin,) {
    return checkPinService(dio, localeName, pin,);
  }

  Future<SetupPinResponseModel> setupPin(String localeName, String pin,) {
    return setupPinService(dio, localeName, pin,);
  }
}
