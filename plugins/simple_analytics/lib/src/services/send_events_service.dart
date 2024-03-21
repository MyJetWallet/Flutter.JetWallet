import 'dart:async';

import 'package:amplitude_flutter/amplitude.dart';

typedef LogEventFunc = Future<void> Function({
  required String name,
  required Map<String, dynamic> body,
});

class SendEventsService {
  final _amplitude = Amplitude.getInstance();

  late final LogEventFunc _logEventFunc;

  Future<void> init(
    String apiKey, {
    String? userId,
    required LogEventFunc logEventFunc,
  }) async {
    _logEventFunc = logEventFunc;
    await _amplitude.init(apiKey);
  }

  Future<void> setUserId(String? userId, {bool? startNewSession}) async {
    await _amplitude.setUserId(userId);
  }

  Future<void> logEvent(
    String eventType, {
    Map<String, dynamic> eventProperties = const <String, dynamic>{},
    bool? outOfSession,
  }) async {
    try {
      await _amplitude.logEvent(
        eventType,
        eventProperties: eventProperties,
      );

      await _logEventFunc(name: eventType, body: eventProperties);
    } catch (e) {
      return;
    }
  }
}
