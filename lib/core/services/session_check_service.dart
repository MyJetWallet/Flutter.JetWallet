import 'dart:async';

import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/local_storage_service.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:logger/logger.dart';
import 'package:simple_networking/modules/auth_api/models/session_chek/session_check_response_model.dart';
import 'package:simple_networking/modules/logs_api/models/add_log_model.dart';

class SessionCheckService {
  SessionCheckResponseModel? data;

  Future<SessionCheckResponseModel?> sessionCheck() async {
    final logger = getIt.get<SimpleLoggerService>();
    const loggerValue = 'StartupService';

    final infoRequest = await sNetwork.getAuthModule().postSessionCheck();

    if (infoRequest.hasError) {
      logger.log(
        level: Level.error,
        place: loggerValue,
        message: 'Failed to fetch session info: ${infoRequest.error}',
      );

      return null;
    } else {
      unawaited(
        getIt.get<SNetwork>().simpleNetworkingUnathorized.getLogsApiModule().postAddLog(
              AddLogModel(
                level: 'info',
                message: '${infoRequest.data}',
                source: 'makeSessionCheck',
                process: 'StartupService',
                token: await getIt.get<LocalStorageService>().getValue(refreshTokenKey),
              ),
            ),
      );

      data = infoRequest.data;

      return infoRequest.data;
    }
  }
}
