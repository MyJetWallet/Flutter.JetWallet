import 'package:redux/redux.dart';

import '../../api/model/authentication.dart';
import '../../api/spot_wallet_client.dart';
import '../../app_state.dart';
import '../../state/config/config_storage.dart';
import '../loader/loader_actions.dart';
import 'registration/registration_actions.dart';

class SetEmail {
  SetEmail(this.email);

  String email;
}

class SetPassword {
  SetPassword(this.password);

  String password;
}

class SetIsPasswordVisible {
  SetIsPasswordVisible();
}

Function authenticate(SpotWalletClient client, ConfigStorage configStorage,
    String email, String password) {
  return (Store<AppState> store) async {
    store.dispatch(SetIsLoading(true));

    final response =
        await client.authenticate(AuthenticationBody(email, password));
    handleResponse(store, response, successHandler: () {
      final registrationResponse =
          AuthenticationResponse.fromJson(response.data);
      store.dispatch(
          authorize(client, configStorage, registrationResponse.token, email));
    });
  };
}
