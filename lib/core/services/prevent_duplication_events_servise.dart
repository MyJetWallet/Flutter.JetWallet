Map<String, int> _lastTimeSendedEvents = {};
const _timeDiff = 3000;

class PreventDuplicationEventsService {
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
