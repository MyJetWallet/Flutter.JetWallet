import 'package:jetwallet/app_state.dart';
import 'package:redux/redux.dart';

class LoaderViewModel {
  LoaderViewModel({required this.isLoading});

  factory LoaderViewModel.fromStore(Store<AppState> store) {
    return LoaderViewModel(
      isLoading: store.state.loaderState.isLoading,
    );
  }

  final bool isLoading;
}
