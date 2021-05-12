import 'package:meta/meta.dart';
import 'package:redux/redux.dart';

import 'user_actions.dart';

@immutable
class UserState {
  const UserState({required this.email, required this.token});

  factory UserState.empty() {
    return const UserState(email: '', token: '');
  }

  final String email;
  final String token;

  UserState copyWith({
    String? email,
    String? token,
  }) {
    return UserState(
      email: email ?? this.email,
      token: token ?? this.token,
    );
  }
}

UserState setUser(
  UserState state,
  SetUser action,
) {
  return state.copyWith(
    email: action.email,
    token: action.token,
  );
}

Reducer<UserState> userReducer = combineReducers<UserState>([
  TypedReducer<UserState, SetUser>(setUser),
]);
