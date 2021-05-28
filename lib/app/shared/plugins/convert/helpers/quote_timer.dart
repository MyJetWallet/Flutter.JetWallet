import 'dart:async';

Stream<int> quoteTimer(int n) async* {
  for (var i = n; i >= 0; i--) {
    await Future.delayed(const Duration(seconds: 1));
    yield i;
  }
}
