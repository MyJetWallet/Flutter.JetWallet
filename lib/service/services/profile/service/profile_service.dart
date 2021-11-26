import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/profile_info_reponse_model.dart';
import 'services/profile_info_service.dart';

class ProfileService {
  ProfileService(this.dio);

  final Dio dio;

  static final logger = Logger('ProfileService');

  Future<ProfileInfoResponseModel> info() {
    return profileInfoService(dio);
  }
}
