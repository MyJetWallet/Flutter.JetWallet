import 'package:jetwallet/api/model/authorization.dart';
import 'package:jetwallet/api/model/registration.dart';
import 'package:jetwallet/api/spot_wallet_client.dart';
import 'package:jetwallet/app_navigator/actions.dart';
import 'package:jetwallet/app_state.dart';
import 'package:jetwallet/global/const.dart';
import 'package:jetwallet/screens/loader/loader_actions.dart';
import 'package:jetwallet/state/config/config_storage.dart';
import 'package:jetwallet/state/user/user_actions.dart';
import 'package:redux/redux.dart';

class SetEmail {
  SetEmail(this.email);

  String email;
}

class SetPassword {
  SetPassword(this.password);

  String password;
}

class SetRepeatPassword {
  SetRepeatPassword(this.repeatPassword);

  String repeatPassword;
}

class SetIsPasswordVisible {
  SetIsPasswordVisible();
}

class SetIsRepeatPasswordVisible {
  SetIsRepeatPasswordVisible();
}

Function register(
  SpotWalletClient client,
  ConfigStorage configStorage,
  String email,
  String password,
) {
  return (Store<AppState> store) async {
    store.dispatch(SetIsLoading(true));

    final response = await client.register(RegistrationBody(email, password));
    handleResponse(store, response, successHandler: () {
      final registrationResponse = RegistrationResponse.fromJson(response.data);
      store.dispatch(
          authorize(client, configStorage, registrationResponse.token, email));
    });
  };
}

Function authorize(SpotWalletClient client, ConfigStorage configStorage,
    String authToken, String email) {
  return (Store<AppState> store) async {
    final response = await client.authorize(AuthorizationBody(authToken));
    final token = response.data.toString();
    client.token = token;
    handleResponse(store, response, successHandler: () {
      store.dispatch(saveUser(token, configStorage, email: email));
    });
  };
}

Function saveUser(String token, ConfigStorage configStorage, {String? email}) {
  return (Store<AppState> store) async {
    await configStorage.setString(tokenKey, token);

    store
      ..dispatch(SetUser(token, email: email))
      ..dispatch(PushNamedAndRemoveUntil('/home'));
  };
}
