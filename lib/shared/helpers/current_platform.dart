import 'package:flutter/foundation.dart';

int get currentAppPlatform {
  if (kIsWeb) {
    return 0;
  } else {
    return 1;
  }
}

int get currentPlatform {
  if (kIsWeb) {
    return 3;
  } else {
    return 2;
  }
}
