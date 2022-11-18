import 'dart:convert';

import 'package:data_channel/data_channel.dart';
import 'package:dio/dio.dart';
import 'package:simple_networking/helpers/models/server_reject_exception.dart';
import 'package:simple_networking/modules/remote_config/models/remote_config_model.dart';

class RemoteConfigDataSources {
  Future<DC<ServerRejectException, RemoteConfigModel>> getRemoteConfigRequest(
    String url,
  ) async {
    try {
      final response = await Dio().get(
        '$url/remote-config/config',
      );

      try {
        Map<String, dynamic> responseData;

        responseData = response.data is String
            ? jsonDecode(response.data as String) as Map<String, dynamic>
            : response.data as Map<String, dynamic>;

        return DC.data(RemoteConfigModel.fromJson(responseData));
      } catch (e) {
        rethrow;
      }
    } on ServerRejectException catch (e) {
      return DC.error(e);
    }
  }
}
