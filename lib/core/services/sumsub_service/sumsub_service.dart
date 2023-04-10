import 'package:flutter/material.dart';
import 'package:flutter_idensic_mobile_sdk_plugin/flutter_idensic_mobile_sdk_plugin.dart';
import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/l10n/i10n.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:jetwallet/core/services/simple_networking/simple_networking.dart';
import 'package:logger/logger.dart';

const String _loggerService = 'SumsubService';

class SumsubService {
  Future<String?> getSDKToken() async {
    final request = await sNetwork.getWalletModule().postSDKToken();

    if (request.hasError) {
      getIt.get<SimpleLoggerService>().log(
            level: Level.error,
            place: _loggerService,
            message: 'Get SDK Token error: ${request.error}',
          );
    }

    return request.data;
  }

  Future<void> launch() async {
    getIt.get<SimpleLoggerService>().log(
          level: Level.info,
          place: _loggerService,
          message: 'Launch',
        );

    onStatusChanged(
        SNSMobileSDKStatus newStatus, SNSMobileSDKStatus prevStatus) {
      print('The SDK status was changed: $prevStatus -> $newStatus');
    }

    final initToken = await getSDKToken();

    print(initToken);

    final snsMobileSDK = SNSMobileSDK.init(initToken ?? '', getSDKToken)
        .withHandlers(
          onStatusChanged: onStatusChanged,
        )
        .withDebug(true)
        .withLocale(
          Locale(intl.localeName),
        )
        .build();

    final SNSMobileSDKResult result = await snsMobileSDK.launch();

    print(result);
  }
}
