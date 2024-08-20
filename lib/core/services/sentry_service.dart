import 'package:jetwallet/core/di/di.dart';
import 'package:jetwallet/core/services/logger_service/logger_service.dart';
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class SentryService {
  SentryService({
    required this.environment,
  });

  final String environment;

  void init() {
    const dsn = String.fromEnvironment(
      'SENTRY_DSN',
      defaultValue: 'https://9fabc8f80d101446661894ba55095845@o4507774924685312.ingest.de.sentry.io/4507774969380944',
    );

    SentryFlutter.init((options) {
      options.environment = environment;

      options.dsn = dsn;
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    });
  }

  void captureException(dynamic throwable, StackTrace stackTrace) {
    Sentry.captureException(throwable, stackTrace: stackTrace);
    getIt.get<SimpleLoggerService>().log(
          level: Level.info,
          place: 'SentryService',
          message: 'Sentry capture exception: $throwable',
        );
  }
}
