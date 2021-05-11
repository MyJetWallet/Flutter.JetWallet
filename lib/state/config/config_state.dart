import 'package:jetwallet/state/config/config_actions.dart';
import 'package:redux/redux.dart';
import 'package:meta/meta.dart';

@immutable
class AppConfigState {
  const AppConfigState(
      {required this.appVersion, required this.appBuildNumber});

  factory AppConfigState.empty() {
    return const AppConfigState(appVersion: '', appBuildNumber: '');
  }

  final String appVersion;
  final String appBuildNumber;

  AppConfigState copyWith({
    String? appVersion,
    String? appBuildNumber,
  }) {
    return AppConfigState(
        appVersion: appVersion ?? this.appVersion,
        appBuildNumber: appBuildNumber ?? this.appBuildNumber);
  }
}

AppConfigState setCurrentBuildVersion(
  AppConfigState state,
  SetCurrentBuildVersion action,
) {
  return state.copyWith(
    appVersion: action.version,
    appBuildNumber: action.build,
  );
}

Reducer<AppConfigState> appConfigReducer = combineReducers<AppConfigState>([
  TypedReducer<AppConfigState, SetCurrentBuildVersion>(setCurrentBuildVersion),
]);
