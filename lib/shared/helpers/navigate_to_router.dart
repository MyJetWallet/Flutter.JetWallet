import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:simple_kit/simple_kit.dart';

/// Navigates to the first route aka [initialRoute] aka [Router()]
void navigateToRouter(Reader read) {
  read(sNavigatorKeyPod).currentState!.popUntil(
    (route) {
      return route.isFirst == true;
    },
  );
}
