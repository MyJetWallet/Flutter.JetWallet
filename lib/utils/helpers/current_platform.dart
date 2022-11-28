import 'package:flutter/foundation.dart';

int get currentAppPlatform {
  return kIsWeb ? 0 : 1;
}

int get currentPlatform {
  return kIsWeb ? 3 : 2;
}
