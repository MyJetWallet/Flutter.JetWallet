// ignore_for_file: use_setters_to_change_properties

import 'dart:async';

import 'package:amplitude_flutter/amplitude.dart';
import 'package:flutter/foundation.dart';

typedef LogEventFunc = Future<bool> Function({
  required String name,
  required Map<String, dynamic> body,
  required int orderIndex,
  required bool amp,
});

class SendEventsService {
  // final _amplitude = Amplitude.getInstance();

  late LogEventFunc _logEventFunc;

  int orderIndex = DateTime.now().millisecondsSinceEpoch;

  bool _useAmplitude = true;

  bool _allowedSendEventsToAmplitude = true;

  Future<void> init(
    String apiKey, {
    String? userId,
    required LogEventFunc logEventFunc,
    bool useAmplitude = true,
    bool allowedSendEventsToAmplitude = true,
  }) async {
    _allowedSendEventsToAmplitude = allowedSendEventsToAmplitude;

    _logEventFunc = logEventFunc;
    _useAmplitude = useAmplitude && !kIsWeb;

    if (_useAmplitude) {
      // await _amplitude.setServerZone('EU');
      // await _amplitude.init(apiKey);
    }
  }

  Future<void> setUserId(String? userId, {bool? startNewSession}) async {
    if (_useAmplitude) {
      // await _amplitude.setUserId(userId?.toLowerCase());
    }
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
      orderIndex++;
      final localOrderIndex = orderIndex;
      if (_useAmplitude) {
        if (_allowedSendEventsToAmplitude) {
          // await _amplitude.logEvent(
          //   eventType,
          //   eventProperties: eventProperties,
          // );
        }
      }

      _allowedSendEventsToAmplitude = !(await _logEventFunc(
        name: eventType,
        body: eventProperties,
        orderIndex: localOrderIndex,
        amp: _allowedSendEventsToAmplitude,
      ));
    } catch (e) {
      return;
    }
  }
}
