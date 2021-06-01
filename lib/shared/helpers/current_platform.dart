import 'package:flutter/foundation.dart';

int get currentPlatform {
  if (kIsWeb) {
    return 0;
  } else {
    return 1;
  }
}
