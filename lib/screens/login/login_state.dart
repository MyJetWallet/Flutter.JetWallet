import 'package:jetwallet/screens/login/login_actions.dart';
import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

@immutable
class LoginState {
  const LoginState({
    required this.email,
    required this.emailError,
    required this.password,
    required this.isPasswordVisible,
  });

  factory LoginState.empty() {
    return const LoginState(
      email: '',
      emailError: '',
      password: '',
      isPasswordVisible: false,
    );
  }

  final String email;
  final String emailError;
  final String password;
  final bool isPasswordVisible;

  LoginState copyWith({
    String? email,
    String? emailError,
    String? password,
    bool? isPasswordVisible,
  }) {
    return LoginState(
      email: email ?? this.email,
      emailError: emailError ?? this.emailError,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    );
  }
}

LoginState setEmail(
  LoginState state,
  SetEmail action,
) {
  return state.copyWith(email: action.email);
}

LoginState setPassword(
  LoginState state,
  SetPassword action,
) {
  return state.copyWith(password: action.password);
}

LoginState setIsPasswordVisible(
  LoginState state,
  SetIsPasswordVisible action,
) {
  return state.copyWith(isPasswordVisible: !state.isPasswordVisible);
}

Reducer<LoginState> loginReducer = combineReducers<LoginState>([
  TypedReducer<LoginState, SetEmail>(setEmail),
  TypedReducer<LoginState, SetPassword>(setPassword),
  TypedReducer<LoginState, SetIsPasswordVisible>(setIsPasswordVisible),
]);
