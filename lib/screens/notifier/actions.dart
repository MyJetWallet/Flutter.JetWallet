import 'package:redux/redux.dart';

import '../../app_state.dart';

class ShowError {
  ShowError(this.message);

  String message;
}

class HideError {}

Function showError(String message) {
  return (Store<AppState> store) async {
    store.dispatch(ShowError(message));

    Future.delayed(const Duration(seconds: 4), () {
      store.dispatch(HideError());
    });
  };
}
