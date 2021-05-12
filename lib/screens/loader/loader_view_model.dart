import 'package:redux/redux.dart';

import '../../app_state.dart';

class LoaderViewModel {
  LoaderViewModel({required this.isLoading});

  factory LoaderViewModel.fromStore(Store<AppState> store) {
    return LoaderViewModel(
      isLoading: store.state.loaderState.isLoading,
    );
  }

  final bool isLoading;
}
