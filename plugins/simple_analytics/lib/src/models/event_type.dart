enum EventType {
  screenView('screen view'),
  tap('tap'),
  error('error'),
  swipe('swipe');

  const EventType(this.name);
  final String name;
}
