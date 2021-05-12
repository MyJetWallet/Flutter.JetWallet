import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';

import 'actions.dart';

@immutable
class NotifierState {
  const NotifierState(
    this.message,
  );

  factory NotifierState.empty() {
    return const NotifierState('');
  }

  final String message;

  NotifierState copyWith({
    String? message,
  }) {
    return NotifierState(
      message ?? this.message,
    );
  }
}

NotifierState showErrorReducer(
  NotifierState state,
  ShowError action,
) {
  return state.copyWith(message: action.message);
}

NotifierState hideErrorReducer(
  NotifierState state,
  HideError action,
) {
  return state.copyWith(message: '');
}

Reducer<NotifierState> notifierReducer = combineReducers<NotifierState>([
  TypedReducer<NotifierState, ShowError>(showErrorReducer),
  TypedReducer<NotifierState, HideError>(hideErrorReducer),
]);
