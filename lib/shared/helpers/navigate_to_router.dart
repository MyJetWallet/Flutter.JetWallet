import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../providers/other/navigator_key_pod.dart';

/// Navigates to the first route aka [initialRoute] aka [Router()]
void navigateToRouter(Reader read) {
  read(navigatorKeyPod).currentState!.popUntil(
    (route) {
      return route.isFirst == true;
    },
  );
}
