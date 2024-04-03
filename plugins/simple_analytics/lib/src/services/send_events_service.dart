// ignore_for_file: use_setters_to_change_properties

import 'dart:async';

import 'package:amplitude_flutter/amplitude.dart';

typedef LogEventFunc = Future<void> Function({
  required String name,
  required Map<String, dynamic> body,
});

class SendEventsService {
  final _amplitude = Amplitude.getInstance();

  late LogEventFunc _logEventFunc;

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

  void updateLogEventFunc(LogEventFunc newLogEventFunc) {
    _logEventFunc = newLogEventFunc;
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
