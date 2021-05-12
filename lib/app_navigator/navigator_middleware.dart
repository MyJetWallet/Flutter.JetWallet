import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import 'actions.dart';

mixin AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}

void navigatorMiddleware<State>(
  Store<State> store,
  action,
  NextDispatcher next,
) {
  if (action is PushNamed) {
    AppNavigator.navigatorKey.currentState?.pushNamed(action.route);
  } else if (action is Pop) {
    AppNavigator.navigatorKey.currentState?.pop();
  } else if (action is PopAndPushNamed) {
    AppNavigator.navigatorKey.currentState?.popAndPushNamed(action.route);
  } else if (action is PushReplaceNamed) {
    AppNavigator.navigatorKey.currentState?.pushReplacementNamed(action.route);
  } else if (action is PushNamedAndRemoveUntil) {
    AppNavigator.navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(action.route, (route) => false);
  } else {
    next(action);
  }
}
