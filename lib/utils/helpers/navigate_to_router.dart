import 'package:jetwallet/core/router/app_router.dart';

/// Navigates to the first route aka [initialRoute] aka [Router()]
void navigateToRouter() {
  sRouter.popUntil((route) => route.isFirst);
}
