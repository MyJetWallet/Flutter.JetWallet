import 'package:injectable/injectable.dart';

// Service to prevent sending duplicate events to analytics
// The service saves the time of the last event sending by id.
// If less than _timeDiff seconds have passed, the same event will not be sent.

@LazySingleton()
class PreventDuplicationEventsService {
  PreventDuplicationEventsService();

  final Map<String, int> _lastTimeSendedEvents = {};
  static const _timeDiff = 3000;

  void sendEvent({
    required String id,
    required void Function() event,
  }) {
    final now = DateTime.now().millisecondsSinceEpoch;

    if (_lastTimeSendedEvents.containsKey(id)) {
      if (now - _lastTimeSendedEvents[id]! > _timeDiff) {
        _lastTimeSendedEvents[id] = now;
        event();
      }
    } else {
      _lastTimeSendedEvents.addEntries({id: now}.entries);

      event();
    }
  }
}
