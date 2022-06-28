import 'package:dio/dio.dart';
import 'package:logging/logging.dart';

import '../model/profile_delete_reasons_model.dart';
import '../model/profile_info_reponse_model.dart';
import 'services/profile_delete.dart';
import 'services/profile_delete_reasons_service.dart';
import 'services/profile_info_service.dart';

class ProfileService {
  ProfileService(this.dio);

  final Dio dio;

  static final logger = Logger('ProfileService');

  Future<ProfileInfoResponseModel> info(String localeName) {
    return profileInfoService(dio, localeName);
  }

  Future<List<ProfileDeleteReasonsModel>> deleteReasons(String localeName) {
    return profileDeleteReasonsService(dio, localeName);
  }

  Future<void> deleteProfile(List<String> deletionReasonIds) {
    return profileDeleteService(dio, deletionReasonIds);
  }
}
