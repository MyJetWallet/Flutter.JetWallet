import 'dart:async';

import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:logger/logger.dart';
//import 'package:sentry_flutter/sentry_flutter.dart';

class SentryService {
  SentryService({
    required this.environment,
  });

  final String environment;

  void init() {
    // const dsn = String.fromEnvironment(
    //   'SENTRY_DSN',
    //   defaultValue: 'https://9fabc8f80d101446661894ba55095845@o4507774924685312.ingest.de.sentry.io/4507774969380944',
    // );

    // SentryFlutter.init((options) {
    //   options.environment = environment;

    //   options.dsn = dsn;
    //   options.tracesSampleRate = 1.0;
    //   options.profilesSampleRate = 1.0;

    //   options.beforeSend = beforeSend;
    // });
  }

  void captureException(dynamic throwable, StackTrace stackTrace) {
    // Sentry.captureException(throwable, stackTrace: stackTrace);
    // getIt.get<SimpleLoggerService>().log(
    //       level: Level.info,
    //       place: 'SentryService',
    //       message: 'Sentry capture exception: $throwable',
    //     );
  }

  // FutureOr<SentryEvent?> beforeSend(SentryEvent event, Hint hint) async {
  //   var sendEvent = true;

  //   if (event.exceptions != null) {
  //     ///
  //     /// ClientException
  //     ///
  //     if (event.exceptions!.last.type == 'ClientException') {
  //       ///
  //       /// ClientException with SocketException
  //       ///
  //       if (event.exceptions!.last.value!.contains('ClientException with SocketException')) {
  //         sendEvent = false;
  //       }
  //     }

  //     ///
  //     /// Socket Exception
  //     ///
  //     if (event.exceptions!.last.type == 'SocketException') {
  //       ///
  //       /// Socket Exception Reading from a closed socket
  //       ///
  //       if (event.exceptions!.last.value!.contains('Reading from a closed socket')) {
  //         sendEvent = false;
  //       }
  //     }

  //     ///
  //     /// Dio Exception
  //     ///
  //     if (event.exceptions!.last.type == 'DioException') {
  //       ///
  //       /// Dio Exception [bad response]
  //       ///
  //       if (event.exceptions!.last.value!.contains('[bad response]')) {
  //         ///
  //         /// 403 code
  //         ///
  //         if (event.exceptions!.last.value!.contains('code of 403')) {
  //           sendEvent = false;
  //         }

  //         ///
  //         /// 401 code
  //         ///
  //         if (event.exceptions!.last.value!.contains('code of 401')) {
  //           sendEvent = false;
  //         }
  //       }

  //       ///
  //       /// Dio Exception [unknown]
  //       ///
  //       if (event.exceptions!.last.value!.contains('[unknown]')) {
  //         sendEvent = false;
  //       }

  //       ///
  //       /// Dio Exception [connection error]
  //       ///
  //       if (event.exceptions!.last.value!.contains('[connection error]')) {
  //         sendEvent = false;
  //       }
  //     }

  //     ///
  //     /// StateError
  //     ///
  //     if (event.exceptions!.last.type == 'StateError') {
  //       ///
  //       /// StateError You tried to access an instance of SignalRService that is not ready yet
  //       ///
  //       if (event.exceptions!.last.value!.contains('instance of SignalRService')) {
  //         sendEvent = false;
  //       }
  //     }
  //   }

  //   return sendEvent ? event : null;
  // }
}
