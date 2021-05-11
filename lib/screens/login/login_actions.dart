import 'package:jetwallet/api/model/authentication.dart';
import 'package:jetwallet/api/spot_wallet_client.dart';
import 'package:jetwallet/app_state.dart';
import 'package:jetwallet/screens/loader/loader_actions.dart';
import 'package:jetwallet/screens/login/registration/registration_actions.dart';
import 'package:jetwallet/state/config/config_storage.dart';
import 'package:redux/redux.dart';

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
