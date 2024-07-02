import 'dart:math';

class SignalRConecrionUrlService {
  void init({required List<String> urls}) {
    _urls = urls;
    _currentIndex = Random().nextInt(_urls.length);
  }

  List<String> _urls = [];

  var _currentIndex = 0;

  String getUrl() {
    if (_currentIndex >= _urls.length ) {
      _currentIndex = 0;
    }
    final result = _urls[_currentIndex];
    _currentIndex++;

    return result;
  }
}
