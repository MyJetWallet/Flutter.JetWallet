import 'package:dio/dio.dart';
import 'package:logging/logging.dart';
import 'package:simple_networking/services/profile/model/profile_delete_reasons_model.dart';
import 'package:simple_networking/services/profile/service/profile_delete_reasons_service.dart';

import '../model/profile_info_reponse_model.dart';
import 'services/profile_info_service.dart';

class ProfileService {
  ProfileService(this.dio);

  final Dio dio;

  static final logger = Logger('ProfileService');

  Future<ProfileInfoResponseModel> info(String localeName) {
    return profileInfoService(dio, localeName);
  }

  Future<ProfileDeleteReasonsModel> deleteReasons(String localeName) {
    return profileDeleteReasonsService(dio, localeName);
  }
}
