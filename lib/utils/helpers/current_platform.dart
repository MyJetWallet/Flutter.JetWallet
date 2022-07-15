import 'package:flutter/foundation.dart';

int get currentPlatform {
  return kIsWeb ? 0 : 1;
}
