import 'package:jetwallet/core/router/app_router.dart';

/// Navigates to the first route aka [initialRoute] aka [Router()]
void navigateToRouter() {
  Future.delayed(Duration.zero, () {
    sRouter.popUntil((route) => route.isFirst);
  });
}
