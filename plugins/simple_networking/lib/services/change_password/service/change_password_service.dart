import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/change_password_request_model.dart';
import 'services/confirm_new_password_service.dart';


class ChangePasswordService {
  ChangePasswordService(this.dio);

  final Dio dio;

  static final logger = Logger('ChangePasswordService');

  Future<void> confirmNewPassword(ChangePasswordRequestModel model) async {
    return confirmNewPasswordService(dio, model);
  }
}
