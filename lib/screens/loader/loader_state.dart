import 'package:jetwallet/screens/loader/loader_actions.dart';
import 'package:redux/redux.dart';
import 'package:meta/meta.dart';

@immutable
class LoaderState {
  const LoaderState({required this.isLoading});

  factory LoaderState.empty() {
    return const LoaderState(isLoading: false);
  }

  final bool isLoading;

  LoaderState copyWith({
    bool? isLoading,
  }) {
    return LoaderState(isLoading: isLoading ?? this.isLoading);
  }
}

LoaderState setIsLoading(
  LoaderState state,
  SetIsLoading action,
) {
  return state.copyWith(
    isLoading: action.isLoading,
  );
}

Reducer<LoaderState> loaderReducer = combineReducers<LoaderState>([
  TypedReducer<LoaderState, SetIsLoading>(setIsLoading),
]);
