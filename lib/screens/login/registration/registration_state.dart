import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

import 'registration_actions.dart';

@immutable
class RegistrationState {
  const RegistrationState({
    required this.email,
    required this.password,
    required this.repeatPassword,
    required this.isPasswordVisible,
    required this.isRepeatPasswordVisible,
  });

  factory RegistrationState.empty() {
    return const RegistrationState(
      email: '',
      password: '',
      repeatPassword: '',
      isPasswordVisible: false,
      isRepeatPasswordVisible: false,
    );
  }

  final String email;
  final String password;
  final String repeatPassword;
  final bool isPasswordVisible;
  final bool isRepeatPasswordVisible;

  RegistrationState copyWith({
    String? email,
    String? password,
    String? repeatPassword,
    bool? isPasswordVisible,
    bool? isRepeatPasswordVisible,
  }) {
    return RegistrationState(
      email: email ?? this.email,
      password: password ?? this.password,
      repeatPassword: repeatPassword ?? this.repeatPassword,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isRepeatPasswordVisible:
          isRepeatPasswordVisible ?? this.isRepeatPasswordVisible,
    );
  }
}

RegistrationState setEmail(
  RegistrationState state,
  SetEmail action,
) {
  return state.copyWith(email: action.email);
}

RegistrationState setPassword(
  RegistrationState state,
  SetPassword action,
) {
  return state.copyWith(password: action.password);
}

RegistrationState setRepeatPassword(
  RegistrationState state,
  SetRepeatPassword action,
) {
  return state.copyWith(repeatPassword: action.repeatPassword);
}

RegistrationState setIsPasswordVisible(
  RegistrationState state,
  SetIsPasswordVisible action,
) {
  return state.copyWith(isPasswordVisible: !state.isPasswordVisible);
}

RegistrationState setIsRepeatPasswordVisible(
  RegistrationState state,
  SetIsRepeatPasswordVisible action,
) {
  return state.copyWith(
      isRepeatPasswordVisible: !state.isRepeatPasswordVisible);
}

Reducer<RegistrationState> registrationReducer =
    combineReducers<RegistrationState>([
  TypedReducer<RegistrationState, SetEmail>(setEmail),
  TypedReducer<RegistrationState, SetPassword>(setPassword),
  TypedReducer<RegistrationState, SetRepeatPassword>(setRepeatPassword),
  TypedReducer<RegistrationState, SetIsPasswordVisible>(setIsPasswordVisible),
  TypedReducer<RegistrationState, SetIsRepeatPasswordVisible>(
      setIsRepeatPasswordVisible),
]);
