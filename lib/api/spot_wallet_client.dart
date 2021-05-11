import 'package:jetwallet/api/dio_client.dart';
import 'package:jetwallet/api/model/authentication.dart';
import 'package:jetwallet/api/model/authorization.dart';
import 'package:jetwallet/api/model/common_response.dart';
import 'package:jetwallet/api/model/refresh.dart';
import 'package:jetwallet/api/model/registration.dart';
import 'package:jetwallet/app_state.dart';
import 'package:jetwallet/global/const.dart';
import 'package:jetwallet/screens/home/account/account_actions.dart';
import 'package:jetwallet/screens/loader/loader_actions.dart';
import 'package:jetwallet/screens/notifier/actions.dart';
import 'package:redux/redux.dart';

class SpotWalletClient {
  SpotWalletClient(this._client);

  final DioClient _client;

  set token(String? token) {
    _client.token = token;
  }

  Future<CommonResponse> register(RegistrationBody registrationBody) async {
    final data = await _client.post(
      '$tradingAuthBaseUrl/Trader/Register',
      body: registrationBody.toJson(),
    );

    return data;
  }

  Future<CommonResponse> authorize(AuthorizationBody authorizationBody) async {
    final data = await _client.post(
      '$walletApiBaseUrl/authorization/authorization',
      body: authorizationBody.toJson(),
    );

    return data;
  }

  Future<CommonResponse> authenticate(
      AuthenticationBody authenticationBody) async {
    final data = await _client.post(
      '$tradingAuthBaseUrl/Trader/Authenticate',
      body: authenticationBody.toJson(),
    );

    return data;
  }

  Future<CommonResponse> refreshToken(RefreshBody refreshBody) async {
    final data = await _client.post(
      '$walletApiBaseUrl/authorization/refresh',
      body: refreshBody.toJson(),
    );

    return data;
  }

  Future<CommonResponse> logOut() async {
    final data = await _client.post(
      '$walletApiBaseUrl/authorization/logout',
    );

    return data;
  }
}

void handleResponse(Store<AppState> store, CommonResponse result,
    {required Function successHandler}) {
  store.dispatch(SetIsLoading(false));
  if (result.result == baseError) {
    store.dispatch(showError(baseError));
  } else if (result.result == unauthorizedError) {
    store.dispatch(logOut());
  } else {
    if (result.result == okSuccessResult ||
        result.result == zeroSuccessResult) {
      successHandler();
    } else {
      store.dispatch(showError(result.result));
    }
  }
}
